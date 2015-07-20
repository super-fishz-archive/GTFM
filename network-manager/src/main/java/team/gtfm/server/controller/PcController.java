package team.gtfm.server.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import team.gtfm.server.bean.Pc;
import team.gtfm.server.bean.UpdateResult;

@RestController
public class PcController {
	private final String contentType = "application/json; charset=utf-8";
	
	@RequestMapping(value="/data/pc", 
			method=RequestMethod.POST,
			consumes=contentType,
			produces=contentType)
	public ResponseEntity<UpdateResult> insertBuilding(@RequestBody Pc pc){
		
		return new ResponseEntity<>(HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/pc/{seq}",
			method=RequestMethod.GET,
			produces=contentType)
	public ResponseEntity<Pc> getBuildings(@PathVariable String seq){
		return new ResponseEntity<>(HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/pc/{seq}",
			method=RequestMethod.DELETE,
			produces=contentType)
	public ResponseEntity<UpdateResult> deleteBuilding(@PathVariable String seq){
		return new ResponseEntity<>(HttpStatus.OK);
	}
	
	@RequestMapping(value="data/pc",
			method=RequestMethod.PUT,
			consumes=contentType,
			produces=contentType)
	public ResponseEntity<UpdateResult> updateBuilding(@RequestBody Pc pc){
		return new ResponseEntity<>(HttpStatus.OK);
	}
}
