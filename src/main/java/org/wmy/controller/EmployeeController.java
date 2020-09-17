package org.wmy.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.wmy.bean.Employee;
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
	 * @return：到list.jsp页面
	 * 查询员工数据（分业查询）
	 */
	@RequestMapping("/emps")
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
