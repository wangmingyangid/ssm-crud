package org.wmy.test;

import java.util.List;
import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.wmy.bean.Department;
import org.wmy.bean.Employee;
import org.wmy.bean.EmployeeExample;
import org.wmy.bean.EmployeeExample.Criteria;
import org.wmy.dao.DepartmentMapper;
import org.wmy.dao.EmployeeMapper;


/**
 * 推荐spring的项目，使用spring的单元测试模块，可以自动注入我们需要的模块
 * 1.导入spring test模块，
 * 2.@ContextConfiguration 指定spring配置文件的位置
 * 3.直接Autowired 即可使用需要的组件
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"classpath:applicationContext.xml"})
public class MapperTest {
	
	@Autowired
	DepartmentMapper depMapper;
	@Autowired
	EmployeeMapper employeeMapper;
	@Autowired
	SqlSession sqlsession;
	
	@Test
	public void testCURD(){
		/*//1.创建spring容器
		ApplicationContext ioc=new ClassPathXmlApplicationContext("applicationContext.xml");
		//2.从容器中获取mapper
		DepartmentMapper bean = ioc.getBean(DepartmentMapper.class);*/
		System.out.println(depMapper);
		
		/*//1.插入几个部门进行测试
		depMapper.insertSelective(new Department(null, "开发部"));
		depMapper.insertSelective(new Department(null, "测试部"));
		*/
		//2.插入几个员工进行测试
		//employeeMapper.insertSelective(new Employee(null, "张飞", "M", "zf@qq.com", 1));
		//3.批量插入员工，使用可以执行批量操作的sqlsession
		/*EmployeeMapper mapper = sqlsession.getMapper(EmployeeMapper.class);
		for(int i=0;i<1000;i++){
			String uid = UUID.randomUUID().toString().substring(0, 5)+i;
			mapper.insertSelective(new Employee(null, uid, "M", uid+"wmy@qq.com", 1));
		}
		System.out.println("批量插入完成");*/
		
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		
		
		/*//有选择的进行更新
		criteria.andEmpNameEqualTo("100ef0");
		Employee employee = new Employee();
		employee.setEmpName("关羽");
		employeeMapper.updateByExampleSelective(employee, example);
		*/
		
		/*//按条件进行查找
		criteria.andEmpIdBetween(1, 10);
		Criteria or = example.or();
		or.andEmpIdBetween(20, 30);
		List<Employee> selectByExample = employeeMapper.selectByExample(example);
		for(Employee employee:selectByExample){
			System.out.println(employee.toString());
		}*/
	}
}
