package org.wmy.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.wmy.bean.Employee;
import org.wmy.bean.EmployeeExample;
import org.wmy.bean.EmployeeExample.Criteria;
import org.wmy.dao.EmployeeMapper;

@Service
public class EmployeeService {

	@Autowired
	EmployeeMapper employeeMapper;
	public List<Employee> getAll() {
		return employeeMapper.selectByExampleWithDep(null);
	}
	public void saveEmp(Employee emp) {
		employeeMapper.insertSelective(emp);
	}
	//检验用户名是否可用
	public boolean checkUser(String empName) {
		EmployeeExample example=new EmployeeExample();
		Criteria criteria = example.createCriteria();
		criteria.andEmpNameEqualTo(empName);
		long res = employeeMapper.countByExample(example);
		return res==0;
	}
	public Employee getEmp(Integer id) {
		Employee emp = employeeMapper.selectByPrimaryKey(id);
		return emp;
	}
	public void updateEmp(Employee employee) {
		employeeMapper.updateByPrimaryKeySelective(employee);
	}
	public void deleteEmyById(Integer id) {
		employeeMapper.deleteByPrimaryKey(id);
		
	}
	public void deleteBatch(List<Integer> ids) {
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		//delete from xxx where emp_id in(1,2,3,,,,)
		criteria.andEmpIdIn(ids);
		employeeMapper.deleteByExample(example);
	}
	
}
