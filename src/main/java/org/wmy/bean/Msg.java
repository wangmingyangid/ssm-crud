package org.wmy.bean;

import java.util.HashMap;
import java.util.Map;

/**
 * @author Administrator
 *	Msg 是自定义的一个通用的服务器结果返回类
 */
public class Msg {
	//100 代表处理成功；200代表处理失败
	private Integer code;
	private String msg;
	private Map<String,Object> extend=new HashMap<>();
	
	public static Msg success(){
		Msg result=new Msg();
		result.setCode(100);
		result.setMsg("处理成功");
		return result;
	}
	public static Msg fail(){
		Msg result=new Msg();
		result.setCode(200);
		result.setMsg("处理失败");
		return result;
	}
	public Msg add(String key,Object value){
		this.extend.put(key, value);
		return this;
	}
	
	public Integer getCode() {
		return code;
	}
	public void setCode(Integer code) {
		this.code = code;
	}
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	public Map<String, Object> getExtend() {
		return extend;
	}
	public void setExtend(Map<String, Object> extend) {
		this.extend = extend;
	}
	
}
