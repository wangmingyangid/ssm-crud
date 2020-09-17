package org.wmy.dao;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import org.wmy.bean.Employee;
import org.wmy.bean.EmployeeExample;

public interface EmployeeMapper {
    long countByExample(EmployeeExample example);

    int deleteByExample(EmployeeExample example);

    int deleteByPrimaryKey(Integer empId);

    int insert(Employee record);

    int insertSelective(Employee record);

    List<Employee> selectByExample(EmployeeExample example);

    Employee selectByPrimaryKey(Integer empId);
    
    //以下方法为新增方法，查出来的员工带部门名
    List<Employee> selectByExampleWithDep(EmployeeExample example);

    Employee selectByPrimaryKeyWithDep(Integer empId);
    

    int updateByExampleSelective(@Param("record") Employee record, @Param("example") EmployeeExample example);

    int updateByExample(@Param("record") Employee record, @Param("example") EmployeeExample example);

    int updateByPrimaryKeySelective(Employee record);

    int updateByPrimaryKey(Employee record);
}