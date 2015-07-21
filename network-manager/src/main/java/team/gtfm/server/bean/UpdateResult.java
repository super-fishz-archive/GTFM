package team.gtfm.server.bean;

public class UpdateResult {
	private boolean result;

	public boolean isResult() {
		return result;
	}

	public void setResult(boolean result) {
		this.result = result;
	}
	
	public void setResult(int c){
		this.result = (c > 0)? true : false;
	}
	
	
	public static UpdateResult create(int c){
		UpdateResult result = new UpdateResult();
		result.setResult(c);
		return result;
	}
}
