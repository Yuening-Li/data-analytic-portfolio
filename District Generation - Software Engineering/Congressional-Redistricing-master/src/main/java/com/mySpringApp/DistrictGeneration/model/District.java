package com.mySpringApp.DistrictGeneration.model;

import java.util.ArrayList; 
import java.util.HashMap;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Transient;

import com.mySpringApp.DistrictGeneration.utils.Weights;
import com.vividsolutions.jts.geom.Coordinate;
import com.vividsolutions.jts.geom.Geometry;
import com.vividsolutions.jts.geom.GeometryFactory;
import com.vividsolutions.jts.geom.LinearRing;
import com.vividsolutions.jts.geom.Polygon;

@Entity
@Table(name = "District")
public class District {

	@ManyToOne
	@JoinColumn(name = "state")
	public State stateId;

	@Id
	@Column(name = "district_id")
	public int districtId;

	@Column(name = "population")
	public int population;

	@Column(name = "republican")
	public int republican;

	@Column(name = "democratic")
	public int democratic;

	@Column(name = "boundary")
	public String boundary;

	@OneToMany(mappedBy = "districtId")
	public List<Precinct> precincts;

	@ManyToMany()
	@JoinTable(name = "BorderPrecincts", joinColumns = @JoinColumn(name = "district"), inverseJoinColumns = @JoinColumn(name = "precinct"))
	public List<Precinct> borderPrecincts;

	@ManyToMany()
	@JoinTable(name = "NeighborDistricts", joinColumns = @JoinColumn(name = "district1"), inverseJoinColumns = @JoinColumn(name = "district2"))
	public List<District> neighborDistricts;

	@Transient
	public double expPopulation;
	
	@Transient 
	double expPartisan;

	@Transient
	public int votingPopulation;

	@Transient
	public double score;
	
	@Transient
	public HashMap<Weights, Double> scoreList;
	
	@Transient
	public static Geometry geometry;
	

	@Transient 
	String color;
	
		
	public District() {
		
	}

	public District(State stateId, int districtId, int population, int republican, int democratic, 
			Geometry geometry, List<Precinct> precincts, List<Precinct> borderPrecincts, String color) {
		this.stateId = stateId;
		this.districtId = districtId;
		this.population = population;
		this.republican = republican;
		this.democratic = democratic;
		this.geometry = geometry;
		this.precincts = precincts;
		this.borderPrecincts = borderPrecincts;
		this.color = color;
		
	}

	public HashMap<Weights, Double> calculateScores() {
		scoreList = new HashMap<Weights, Double>();
		scoreList.put(Weights.POPULATION, calculatePopScore());
		scoreList.put(Weights.COMPACTNESS, calculateCompScore());	
		scoreList.put(Weights.PARTISIAN_FAIRNESS, calculatPartisanScore());
		scoreList.put(Weights.EFFICIENCY_GAP, calculateGapScore());
		return scoreList;
	}
	
	private double calculatPartisanScore() {
		double currRatio = (double)republican/(double)democratic;
		double score = Math.abs(1 - Math.abs(currRatio/expPartisan - 1));
		//System.out.println(this.getDistrictId() + " partisan score: " + score);
		return score;
	}
	
	
	private double calculateGapScore() {
		double demWastedVotes = 0;
        double repWastedVotes = 0;
        double totalVotes = 0;
		for(Precinct p: precincts){
			double total = p.getDemocratic() + p.getRepublican();
			double votes_to_win = (total)/2 + 1;
			if(p.getDemocratic()>p.getRepublican()){
				demWastedVotes  += (p.getDemocratic()-votes_to_win);
				repWastedVotes += p.getRepublican();
			}
			else{
				demWastedVotes+= p.getDemocratic();
				repWastedVotes += (p.getRepublican()-votes_to_win);
			}
			totalVotes = totalVotes +p.getDemocratic()+p.getRepublican();
		}
		double efficiency_gap =Math.abs(demWastedVotes - repWastedVotes) / totalVotes;
		double score = 1 - efficiency_gap;
		//System.out.println(this.getDistrictId() + " efficiency gap score: " + score);
		return score;
	}
	
	private double calculateCompScore() {
		// Formula: (4Pi * area) / (Perimeter^2)
        double polsbyPopperScore = (4 * Math.PI * this.getGeometry().getArea()) / Math.pow(this.getGeometry().getLength(), 2);
       // System.out.println(this.getDistrictId() + " compactness score: " + polsbyPopperScore);
        return polsbyPopperScore;
	}
	
	private double calculatePopScore() {
		double popScore = 1 - Math.abs(population - expPopulation)/ (double)expPopulation;
		//System.out.println(this.getDistrictId() + " population score: " + popScore);
		return popScore;
	}
	

	public Precinct findMovablePrecinct() {

		while (true) {
			int randomBp = (int) (Math.random() * borderPrecincts.size());
			Precinct bp = borderPrecincts.get(randomBp);
			for (int i = 0; i < bp.getNeighborPrecincts().size(); i++) {
				Precinct np = bp.getNeighborPrecincts().get(i);
				if (np.getDistrictById().getDistrictId() != bp.getDistrictById().getDistrictId()) {
					return bp;
				}
			}
		}
	}

	public District selectNeighborDistrict(Precinct p) {
		List<Precinct> nps = p.getNeighborPrecincts();
		for (int i = 0; i < nps.size(); i++) {
			if (nps.get(i).getDistrictById().getDistrictId() != districtId) {
				return nps.get(i).getDistrictById();
			}
		}
		return null;
	}
	
	public Precinct findGrowablePrecinct(List<Precinct> precincts) {
		for(int i = 0; i < this.getBorderPrecincts().size(); i++) {
			Precinct bp = this.getBorderPrecincts().get(i);
			for(int j = 0; j < bp.getNeighborPrecincts().size(); j++) {
				Precinct p = bp.getNeighborPrecincts().get(j);
				if(precincts.contains(p)) {
					return p;
				}
			}
		}
		return null;
	}
	
	public void deleteBorder(Precinct p) {
		List<Precinct> nps = p.getNeighborPrecincts();
		for (int i = 0; i < nps.size(); i++) {
			Precinct np = nps.get(i);
			// if neighbor precinct is in the same district as p, it becomes boundary.
			if (np.getDistrictById().getDistrictId() == p.getDistrictById().getDistrictId()
					&& nps.contains(np) == false) {
				borderPrecincts.add(np);
			}
		}
		borderPrecincts.remove(p);
	}

	public void addBorder(Precinct p) {
		List<Precinct> nps = p.getNeighborPrecincts();
		for (int i = 0; i < nps.size(); i++) {
			Precinct np = nps.get(i);
			/*
			 * if neighbor precinct is in the same district as p AND np does not have
			 * neighbor precincts in another district. then its' not a border precinct
			 */
			if (np.getDistrictById().getDistrictId() == p.getDistrictById().getDistrictId()) {
				boolean toBeRemoved = true;
				for (int j = 0; j < np.getNeighborPrecincts().size(); j++) {
					Precinct nnp = np.getNeighborPrecincts().get(j);
					if (nnp.getDistrictById().getDistrictId() != np.getDistrictById().getDistrictId()) {
						toBeRemoved = false;
						break;
					}
					toBeRemoved = true;
				}
				if (toBeRemoved == true)
					borderPrecincts.remove(np);
				borderPrecincts.add(p);
			}
		}
	}

	public State getStateId() {
		return stateId;
	}

	public void setStateId(State stateId) {
		this.stateId = stateId;
	}

	public int getDistrictId() {
		return districtId;
	}

	public void setDistrictId(int districtId) {
		this.districtId = districtId;
	}

	public int getPopulation() {
		return population;
	}

	public void setPopulation(int population) {
		this.population = population;
	}

	public int getRepublican() {
		return republican;
	}

	public void setRepublican(int republican) {
		this.republican = republican;
	}

	public int getDemocratic() {
		return democratic;
	}

	public void setDemocratic(int democratic) {
		this.democratic = democratic;
	}

	public String getBoundary() {
		return boundary;
	}

	public void setBoundary(String boundary) {
		this.boundary = boundary;
	}

	public List<Precinct> getPrecincts() {
		return precincts;
	}

	public void setPrecincts(List<Precinct> precincts) {
		this.precincts = precincts;
	}

	public List<Precinct> getBorderPrecincts() {
		return borderPrecincts;
	}

	public void setBorderPrecincts(List<Precinct> borderPrecincts) {
		this.borderPrecincts = borderPrecincts;
	}
	
	public List<District> getNeighborDistricts() {
		return neighborDistricts;
	}

	public void setNeighborDistricts(List<District> neighborDistricts) {
		this.neighborDistricts = neighborDistricts;
	}
	
	public double getExpectedPopulation() {
		return expPopulation;
	}

	public void setExpectedPopulation(double expectedPopulation) {
		this.expPopulation = expectedPopulation;
	}

	public int getVotingPopulation() {
		return votingPopulation;
	}

	public void setVotingPopulation(int votingPopulation) {
		this.votingPopulation = votingPopulation;
	}

	public HashMap<Weights, Double> getScoreList() {
		return scoreList;
	}

	public void setScoreList(HashMap<Weights,Double> newScore) {
		scoreList = newScore;
	}
	
	public double getScore() {
		return score;
	}
	
	public void setScore(double score) {
		this.score = score;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}
	
	public Geometry getGeometry() {
		if(geometry == null) {
			GeometryFactory geometryFactory = new GeometryFactory();
			ArrayList<double[]> coordinate = convertCoordinate(this.getBoundary());
			Coordinate[] coordinates = new Coordinate[coordinate.size()];
			for (int j = 0; j < coordinate.size(); j++) {
				Coordinate coord = new Coordinate(coordinate.get(j)[0], coordinate.get(j)[1]);
				coordinates[j] = coord;
			}
			LinearRing ring = geometryFactory.createLinearRing( coordinates );
			LinearRing holes[] = null;
			Polygon polygon = geometryFactory.createPolygon(ring, holes );
			geometry = polygon;
		}
		return geometry;
	}

	public void setGeometry(Geometry geometry) {
		this.geometry = geometry;
	}
		
	public double getExpPartisan() {
		return expPartisan;
	}

	public void setExpectedPartisan(double expPartisan) {
		this.expPartisan = expPartisan;
	}

	public static ArrayList<double[]> convertCoordinate(String str) {
		String[] coordinates = str.split(",");
		ArrayList<double[]> polygon = new ArrayList<double[]>();
		for (int i = 0; i < coordinates.length; i = i + 2) {
			double[] point = new double[2];
				
			double x = Double.parseDouble(coordinates[i].replaceAll("\\[", "").replaceAll("\\]", ""));
			double y = Double.parseDouble(coordinates[i + 1].replaceAll("\\[", "").replaceAll("\\]", ""));
			point[1] = Math.round(x * 1000000D)/1000000D;
			point[0] = Math.round(y * 1000000D)/1000000D;
			polygon.add(point);
		}
		double[] point = new double[2];
		double x = Double.parseDouble(coordinates[0].replaceAll("\\[", "").replaceAll("\\]", ""));
		double y = Double.parseDouble(coordinates[1].replaceAll("\\[", "").replaceAll("\\]", ""));
		point[1] = Math.round(x * 1000000D)/1000000D;
		point[0] = Math.round(y * 1000000D)/1000000D;
		polygon.add(point);
		return polygon;
	}
}
