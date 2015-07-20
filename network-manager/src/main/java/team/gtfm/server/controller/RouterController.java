package team.gtfm.server.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import team.gtfm.server.bean.Router;
import team.gtfm.server.bean.UpdateResult;

@RestController
public class RouterController {
	private final String contentType = "application/json; charset=utf-8";
	
	@RequestMapping(value="/data/router", 
			method=RequestMethod.POST,
			consumes=contentType,
			produces=contentType)
	public ResponseEntity<UpdateResult> insertRoom(@RequestBody Router router){
		return new ResponseEntity<>(HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/router/{seq}", 
			method=RequestMethod.GET,
			produces=contentType)
	public ResponseEntity<Router> getRoom(@PathVariable String seq){
		return new ResponseEntity<>(HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/router/{seq}", 
			method=RequestMethod.DELETE,
			produces=contentType)
	public ResponseEntity<UpdateResult> deleteRoom(@PathVariable String seq){
		return new ResponseEntity<>(HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/router", 
			method=RequestMethod.PUT,
			consumes=contentType,
			produces=contentType)
	public ResponseEntity<UpdateResult> putRoom(@RequestBody Router router){
		return new ResponseEntity<>(HttpStatus.OK);
	}
}
