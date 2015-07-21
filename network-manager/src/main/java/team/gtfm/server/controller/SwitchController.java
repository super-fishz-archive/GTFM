package team.gtfm.server.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import team.gtfm.server.bean.Switch;
import team.gtfm.server.bean.UpdateResult;
import team.gtfm.server.db.SwitchDao;

@RestController
public class SwitchController {
	private final String contentType = "application/json; charset=utf-8";
	
	@Autowired
	private SwitchDao dao;
	
	@RequestMapping(value="/data/switch", 
			method=RequestMethod.POST,
			consumes=contentType,
			produces=contentType)
	public ResponseEntity<UpdateResult> insertRoom(@RequestBody Switch switchObj){
		
		int c = dao.insertSwitch(switchObj);
		return new ResponseEntity<>(UpdateResult.create(c), HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/switch/{seq}", 
			method=RequestMethod.GET,
			produces=contentType)
	public ResponseEntity<Switch> getRoom(@PathVariable String seq){
		
		Switch s = dao.selectSwitch(Integer.parseInt(seq));
		return new ResponseEntity<>(s, HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/switch", 
			method=RequestMethod.GET,
			produces=contentType)
	public ResponseEntity<List<Switch>> getRoom(){
		
		List<Switch> s = dao.selectSwitchAll();
		return new ResponseEntity<>(s, HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/switch/{seq}", 
			method=RequestMethod.DELETE,
			produces=contentType)
	public ResponseEntity<UpdateResult> deleteRoom(@PathVariable String seq){
		
		int c = dao.deleteSwitch(Integer.parseInt(seq));
		return new ResponseEntity<>(UpdateResult.create(c), HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/switch", 
			method=RequestMethod.PUT,
			consumes=contentType,
			produces=contentType)
	public ResponseEntity<UpdateResult> putRoom(@RequestBody Switch switchObj){
		return new ResponseEntity<>(HttpStatus.OK);
	}
}
