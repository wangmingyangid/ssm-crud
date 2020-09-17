package org.wmy.test;

import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;
import org.wmy.bean.Employee;

import com.github.pagehelper.PageInfo;

/**
 * 使用spring提供的测试请求功能，测试crud请求的正确性
 * spring4的测试，需要servlet 3.0的支持
 *
 */
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations={"classpath:applicationContext.xml","file:src/main/webapp/WEB-INF/dispatcherServlet-servlet.xml"})
public class MvcTest {
	//虚拟mvc请求，获得处理结果
	MockMvc mockMvc;
	
	//传入spring mvc 的ioc 容器（是容器本身，不是容器里的内容），需要@WebAppConfiguration
	@Autowired
	WebApplicationContext context;
	
	@Before
	public void initMvc(){
		mockMvc=MockMvcBuilders.webAppContextSetup(context).build();
	}
	@Test
	public void testPage() throws Exception{
		//模拟请求并拿到返回值
		MvcResult result = mockMvc.perform(MockMvcRequestBuilders.
				get("/emps").param("pn", "6")).andReturn();
		
		//请求成功以后，请求域中会有pageInfo对象，可以根据该对象进行验证
		MockHttpServletRequest request = result.getRequest();
		PageInfo pageInfo = (PageInfo) request.getAttribute("pageInfo");
		
		System.out.println("当前页码："+pageInfo.getPageNum());
		System.out.println("总页码："+pageInfo.getPages());
		System.out.println("总记录数："+pageInfo.getTotal());
		System.out.println("在页面需要连续显示的页码");
		int[] navigatepageNums = pageInfo.getNavigatepageNums();
		for(int i:navigatepageNums){
			System.out.print(" "+i);
		}
		System.out.println();
		List<Employee> list = pageInfo.getList();
		for(Employee employee:list){
			System.out.println("ID:"+employee.getEmpId()+"=="+"Name:"+employee.getEmpName());
		}
	}
}
