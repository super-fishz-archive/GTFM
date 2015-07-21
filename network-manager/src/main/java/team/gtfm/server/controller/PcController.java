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

import com.sun.corba.se.spi.orbutil.fsm.Guard.Result;

import team.gtfm.server.bean.Pc;
import team.gtfm.server.bean.UpdateResult;
import team.gtfm.server.db.PcDao;

@RestController
public class PcController {
	private final String contentType = "application/json; charset=utf-8";
	
	@Autowired
	private PcDao dao;
	
	@RequestMapping(value="/data/pc", 
			method=RequestMethod.POST,
			consumes=contentType,
			produces=contentType)
	public ResponseEntity<UpdateResult> insertPc(@RequestBody Pc pc){
		
		int c = dao.insertPc(pc);
		UpdateResult result = new UpdateResult();
		result.setResult(c);
		return new ResponseEntity<>(result, HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/pc/{seq}",
			method=RequestMethod.GET,
			produces=contentType)
	public ResponseEntity<Pc> getPc(@PathVariable String seq){
		
		return new ResponseEntity<>(HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/pc",
			method=RequestMethod.GET,
			produces=contentType)
	public ResponseEntity<List<Pc>> getPcAll(){
		
		List<Pc> list = dao.selectPcAll();
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
	
	@RequestMapping(value="/data/pc/{seq}",
			method=RequestMethod.DELETE,
			produces=contentType)
	public ResponseEntity<UpdateResult> deletePc(@PathVariable String seq){
		int c = dao.deletePc(Integer.parseInt(seq));
		UpdateResult result = new UpdateResult();
		result.setResult(c);
		return new ResponseEntity<>(result, HttpStatus.OK);
	}
	
	@RequestMapping(value="data/pc",
			method=RequestMethod.PUT,
			consumes=contentType,
			produces=contentType)
	public ResponseEntity<UpdateResult> updatePc(@RequestBody Pc pc){
		return new ResponseEntity<>(HttpStatus.OK);
	}
}
