package org.wmy.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.wmy.bean.Employee;
import org.wmy.bean.Msg;
import org.wmy.service.EmployeeService;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

/**
 * @author Administrator
 *	处理员工CRUD
 */
@Controller
public class EmployeeController {
	@Autowired
	EmployeeService employeeService;
	
	/**
	 * 单个、批量二合一删除
	 * 批量删除：1-2-3
	 * 单个删除：1
	 * 
	 */
	@ResponseBody
	@RequestMapping(value="/emp/{ids}",method=RequestMethod.DELETE)
	public Msg deleteEmpById(@PathVariable("ids")String ids){
		if(ids.contains("-")){
			//批量删除
			List<Integer> list=new ArrayList<>();
			String[] str_ids = ids.split("-");
			for(String str:str_ids){
				list.add(Integer.parseInt(str));
			}
			employeeService.deleteBatch(list);
		}else{
			//单个删除
			Integer id = Integer.parseInt(ids);
			employeeService.deleteEmyById(id);
		}
		
		return Msg.success();
	}
	 
	/**
	 * @param employee
	 * 员工更新方法
	 * @RequestMapping(value="/emp/{empId}",method=RequestMethod.PUT)
	 * value="/emp/{empId}中 必须是empId，否则封装不上
	 * 
	 * 如果直接发送ajax=PUT的请求，封装的数据如下：
	 * Employee [empId=1, empName=null, gender=null, email=null, dId=null]
	 * 
	 * 问题：请求体中有数据，但是Employee对象中封装不上
	 * update tal_emp where emp_id=1  (缺少了set 字段)，报sql异常
	 * 
	 * 原因：
	 * Tomcat：
	 * 	1.将请求体中的数据，封装一个map
	 * 	2.request.getParameter("empName")就会从这个map中取值
	 * 	3.SpringMVC封装POJO对象时，通过调用request.getParameter()方法，给属性进行赋值
	 * 
	 * AJAX发送PUT请求出现的问题：
	 * 	PUT请求，请求体中的数据request.getParameter是拿不到的，因为
	 * 	Tomcat一看请求是PUT不会封装请求体中的数据为map，只有POST请求中的数据才会封装map
	 * 
	 * 解决方案：
	 * 要能支持直接发送PUT之类的请求，并封装上数据
	 * 需要配置该过滤器：HttpPutFormContentFilter
	 * 作用：将请求体中的数据解析包装成一个map
	 * request被重新包装，request.getParameter()方法被重写，就会从自己的map中取数据
	 * 
	 * Employee [empId=1, empName=null, gender=F, email=1570a0wmy@qq.com, dId=2]
	 * 
	 */
	@RequestMapping(value="/emp/{empId}",method=RequestMethod.PUT)
	@ResponseBody
	public Msg saveEmp(Employee employee){
		System.out.println(employee);
		employeeService.updateEmp(employee);
		return Msg.success();
	}
	/**
	 * @param id
	 * @return
	 * @PathVariable("id") 表示从路径中取出id进行赋值
	 */
	@RequestMapping(value="/emp/{id}",method=RequestMethod.GET)
	@ResponseBody
	public Msg getEmp(@PathVariable("id")Integer id){
		Employee employee = employeeService.getEmp(id);
		return Msg.success().add("emp", employee);
	}
	
	/**
	 * @param userName
	 * 检查用户名是否可用
	 * @RequestParam：将请求参数绑定到你控制器的方法参数上（是springmvc中接收普通参数的注解）
	 */
	@ResponseBody
	@RequestMapping("/checkuser")
	public Msg checkUser(@RequestParam(value="empName")String userName){
		//先判断用户名是否合法
		String regex="(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})";
		boolean matches = userName.matches(regex);
		if(!matches){
			return Msg.fail().add("vamsg","用户明可以是2-5位中文或者6-16位英文和数字、-、_、的组合");
		}
		
		//数据库用户名重复校验
		boolean b =employeeService.checkUser(userName);
		if(b){
			return Msg.success();
		}else{
			return Msg.fail().add("vamsg", "用户名不可用");
		}
	}
	
	@RequestMapping(value="/emp",method=RequestMethod.POST)
	@ResponseBody
	//前端提供的数据会被自动封装到emp
	public Msg saveEmp(@Valid Employee emp,BindingResult result){
		if(result.hasErrors()){
			//校验失败，应该返回失败，在模态框中显示校验失败的信息
			Map<String,Object> map=new HashMap<>();
			List<FieldError> errors = result.getFieldErrors();
			for(FieldError fieldError:errors){
				System.out.println("错误的字段名"+fieldError.getField());
				System.out.println("错误信息"+fieldError.getDefaultMessage());
				map.put(fieldError.getField(), fieldError.getDefaultMessage());
			}
			return Msg.fail().add("errorFields", map);
		}else{
			employeeService.saveEmp(emp);
			return Msg.success();
		}	
	}
	
	@RequestMapping("/emps")
	@ResponseBody
	public Msg getEmpsWithJson(@RequestParam(value="pn",defaultValue="1")Integer pn){
		//这不是一个分页查询
		//引入PageHelper 插件
		//在查询操作之前，需要先执行以下代码，即可完成分页（传入页码，和每页展示的数目）
		PageHelper.startPage(pn, 5);
		//startPage 后面紧跟的查询就是分页查询
		List<Employee> emps=employeeService.getAll();
		//使用pageinfo包装查询出来的结果；只需要将这个对象交给页面就好了
		//封装了详细的分页信息，包括我们查询出来的数据
		//5代表连续显示的页数
		PageInfo page=new PageInfo(emps,5);
		
		return Msg.success().add("pageInfo", page);
	}
	
	/**
	 * @return：到list.jsp页面
	 * 查询员工数据（分业查询）
	 */
	//@RequestMapping("/emps")
	public String getEmps(@RequestParam(value="pn",defaultValue="1")Integer pn,Model model){
		//这不是一个分页查询
		//引入PageHelper 插件
		//在查询操作之前，需要先执行以下代码，即可完成分页（传入页码，和每页展示的数目）
		PageHelper.startPage(pn, 5);
		//startPage 后面紧跟的查询就是分页查询
		List<Employee> emps=employeeService.getAll();
		//使用pageinfo包装查询出来的结果；只需要将这个对象交给页面就好了
		//封装了详细的分页信息，包括我们查询出来的数据
		//5代表连续显示的页数
		PageInfo page=new PageInfo(emps,5);
		model.addAttribute("pageInfo", page);
		return "list";
	}
}
