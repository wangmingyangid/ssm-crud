package org.wmy.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.wmy.bean.Employee;
import org.wmy.dao.EmployeeMapper;

@Service
public class EmployeeService {

	@Autowired
	EmployeeMapper employeeMapper;
	public List<Employee> getAll() {
		return employeeMapper.selectByExampleWithDep(null);
	}
	
}
