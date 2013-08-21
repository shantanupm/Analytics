package com.ss.user.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/user")
public class LoginController {

	@RequestMapping("/login.html")
	public String login(Model model){
		
		model.addAttribute("hideLinks", true);
		model.addAttribute("hideOnLineLinks", true);
		return "loginPage";
	}
}
