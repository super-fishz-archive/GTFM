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

import team.gtfm.server.bean.Router;
import team.gtfm.server.bean.UpdateResult;
import team.gtfm.server.db.RouterDao;

@RestController
public class RouterController {
	private final String contentType = "application/json; charset=utf-8";
	
	@Autowired
	private RouterDao dao;
	
	@RequestMapping(value="/data/router", 
			method=RequestMethod.POST,
			consumes=contentType,
			produces=contentType)
	public ResponseEntity<UpdateResult> insertRoom(@RequestBody Router router){
		
		int c = dao.insertRouter(router);
		return new ResponseEntity<>(UpdateResult.create(c), HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/router/{seq}", 
			method=RequestMethod.GET,
			produces=contentType)
	public ResponseEntity<Router> getRoom(@PathVariable String seq){
		
		Router router = dao.selectRouter(Integer.parseInt(seq));
		return new ResponseEntity<>(router, HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/router", 
			method=RequestMethod.GET,
			produces=contentType)
	public ResponseEntity<List<Router>> getRoom(){
		
		List<Router> list = dao.selectRouterAll();
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
	
	
	@RequestMapping(value="/data/router/{seq}", 
			method=RequestMethod.DELETE,
			produces=contentType)
	public ResponseEntity<UpdateResult> deleteRoom(@PathVariable String seq){
		int c = dao.deleteRouter(Integer.parseInt(seq));
		return new ResponseEntity<>(UpdateResult.create(c), HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/router", 
			method=RequestMethod.PUT,
			consumes=contentType,
			produces=contentType)
	public ResponseEntity<UpdateResult> putRoom(@RequestBody Router router){
		return new ResponseEntity<>(HttpStatus.OK);
	}
}
