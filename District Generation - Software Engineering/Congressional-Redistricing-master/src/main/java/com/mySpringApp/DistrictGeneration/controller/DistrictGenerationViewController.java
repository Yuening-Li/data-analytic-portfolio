package com.mySpringApp.DistrictGeneration.controller; 

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired; 
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import com.mySpringApp.DistrictGeneration.model.Admin;
import com.mySpringApp.DistrictGeneration.model.RegisteredUser;
import com.mySpringApp.DistrictGeneration.repository.AdminRepository;
import com.mySpringApp.DistrictGeneration.repository.StateRepository;
import com.mySpringApp.DistrictGeneration.repository.UserRepository;
import com.mySpringApp.DistrictGeneration.service.Algorithm;
import com.mySpringApp.DistrictGeneration.utils.Weights;
import com.mySpringApp.DistrictGeneration.model.State;

@Controller
public class DistrictGenerationViewController {
	
	@Autowired
	public UserRepository userRepo;
	@Autowired
	public StateRepository stateRepo;
	@Autowired
	public AdminRepository adminRepo;
	
	Algorithm algo;
	
	@GetMapping("/")
	public String Home() {
		return "home";
	}
	
	@GetMapping("/welcome")
	public String Welcome() {
		return "welcome";
	}
	
	@GetMapping("/state/{id}")
	public String State(@PathVariable("id") int id, Model model) {
		State s = stateRepo.findById(id);
		model.addAttribute("id", id);
		model.addAttribute("districtSize", s.getNumDistrict());
		return "state";
	}

	@GetMapping("/register")
	public String registerForm(Model model) {
		RegisteredUser ru = new RegisteredUser();
		model.addAttribute("newUser", ru);
		return "register";
	}
	
	@PostMapping("/register")
	public String registerSubmit(@ModelAttribute("newUser") RegisteredUser newUser){
		userRepo.save(newUser);
		return "home";
	}
	
	
	@GetMapping("/login")
	public String loginForm(Model model) {
		return "login";
	}
	
	
	@GetMapping("/list")
	public String ListUsers(Model model){
		Iterable<RegisteredUser> users = userRepo.findAll();
		model.addAttribute("users",users);
		return "userList";
	}
	
	@GetMapping("/showFormForAdd")
	public String showFormForAdd(Model model){
		RegisteredUser theUser = new RegisteredUser();
		model.addAttribute("user",theUser);
		return "userForm";
	}
	
	@PostMapping("/saveUser")
	public String saveUser(@ModelAttribute("user")RegisteredUser theUser){		
		userRepo.save(theUser);
		return "redirect:/list";
	}
	
	@GetMapping("/showFormForUpdate")
	public String showFormForUpdate(@RequestParam("id")int theId,
									Model model){
		RegisteredUser theUser = userRepo.findById(theId);
		model.addAttribute("user",theUser);
		return "userForm";
	}
	
	@GetMapping("/showFormForDelete")
	public String showFormForDelete(@RequestParam("id")int theId,
									Model model){
		userRepo.deleteById(theId);
		return "redirect:/list";
	}
	
	@PostMapping("/login")
	public String loginSubmit(
			@RequestParam(value="username", required=true) String username,
			@RequestParam(value="password", required=true) String password) {
			RegisteredUser user = userRepo.findByUsername(username);
			Admin admin = adminRepo.findByUsername(username);
			if(user!=null) {
				return "redirect:/welcome";
			}else if(admin!=null){
				return "redirect:/list";
			}else {
				return "login";
			}
	}
	
	@GetMapping("/logout")
	public String logout(Model model) {
		return "home";
	}

}
