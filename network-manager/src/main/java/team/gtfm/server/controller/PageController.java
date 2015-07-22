package team.gtfm.server.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class PageController {
//	@RequestMapping("/layout")
//	public String goLayout(){
//		return "layout";
//	}
	
	@RequestMapping("/{path}")
	public String goLayout(@PathVariable String path, Model model){
		if(path.equals("layout"))
			path = "index";
		model.addAttribute("path", path);
		return "layout";
	}
	
//	@RequestMapping("/Univ_Page_View")
//	public String goUniv(@RequestParam("building") String seq, Model model){
//		return "Univ_Page_View";
//	}
}
