<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>员工列表</title>

<%
	pageContext.setAttribute("APP_PATH",request.getContextPath());
%>

<!-- 
		web 路径
		不以/开始的相对路径，找资源，以当前资源的路径为基准，经常容易出现问题。
		以/开始的相对路径，找资源，以服务器的路径为标准（http://localhost:3306）；需要加上项目名
			http://localhost:3306/ssm-crud
		
 -->
<!-- 引入jquery -->
<script type="text/javascript" src="${APP_PATH}/static/js/jquery-1.12.4.min.js"></script>

<!-- 引入样式 -->
<link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>

	<!-- 员工修改的模态框 -->
	<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title">员工修改</h4>
	      </div>
	      <div class="modal-body">
	       	<form class="form-horizontal">
	       	
			  <div class="form-group">
			    <label for="empName_add_input" class="col-sm-2 control-label">empName</label>
			    <div class="col-sm-10">
			        <p class="form-control-static" id="empName_update_static"></p>
			    </div>
			  </div>
			  
			  <div class="form-group">
			    <label for="email_add_input" class="col-sm-2 control-label">email</label>
			    <div class="col-sm-10">
			      <input type="text"  name="email" class="form-control" id="email_update__input" placeholder="email@qq.com">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  
			  <div class="form-group">
			    <label for="empName_add_input" class="col-sm-2 control-label">gender</label>
			    <div class="col-sm-10">
			        <label class="radio-inline">
					  <input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked"> 男
					</label>
					<label class="radio-inline">
					  <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
				    </label>
			    </div>
			  </div>
			  
			  <div class="form-group">
			    <label for="empName_add_input" class="col-sm-2 control-label">deptName</label>
			    <div class="col-sm-4">
			    	<!-- 提交部门Id即可 -->
			      <select class="form-control" name="dId" id="dept_update_select">
					  
				  </select>
			    </div>
			  </div>
			  
			  
			</form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
	      </div>
	    </div>
	  </div>
	</div>
	
	
	<!-- 员工添加的模态框 -->
	<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">员工添加</h4>
	      </div>
	      <div class="modal-body">
	       	<form class="form-horizontal">
	       	
			  <div class="form-group">
			    <label for="empName_add_input" class="col-sm-2 control-label">empName</label>
			    <div class="col-sm-10">
			      <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
			   	  <!-- 校验失败的提示 -->
			   	  <span class="help-block"></span>
			    </div>
			  </div>
			  
			  <div class="form-group">
			    <label for="email_add_input" class="col-sm-2 control-label">email</label>
			    <div class="col-sm-10">
			      <input type="text"  name="email" class="form-control" id="email_add_input" placeholder="email@qq.com">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  
			  <div class="form-group">
			    <label for="empName_add_input" class="col-sm-2 control-label">gender</label>
			    <div class="col-sm-10">
			        <label class="radio-inline">
					  <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
					</label>
					<label class="radio-inline">
					  <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
				    </label>
			    </div>
			  </div>
			  
			  <div class="form-group">
			    <label for="empName_add_input" class="col-sm-2 control-label">deptName</label>
			    <div class="col-sm-4">
			    	<!-- 提交部门Id即可 -->
			      <select class="form-control" name="dId" id="dept_add_select">
					  
				  </select>
			    </div>
			  </div>
			  
			  
			</form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
	      </div>
	    </div>
	  </div>
	</div>
	
	<!-- 搭建显示页面，所有的行必须包含在 container类中-->
	<div class="container">
		<!-- 标题 -->
		<div class="row">
			<div class="col-md-12">
				<h1>SSM-CRUD</h1>
			</div>
		</div>
		<!-- 按钮 -->
		<div class="row">
			<!-- 占4列但是偏移8列 -->
			<div class="col-md-4 col-md-offset-8">
				<button class="btn btn-primary" id="emp_add_btn">新增</button>
				<button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
			</div>
		</div>
		<!-- 显示表格数据  tr 表示表行	th表示表头-->
		<div class="row">
			<div class=col-md-12>
				<table class="table table-hover" id="emps_table">
					<thead>
						<tr>
							<th>
								<input type="checkbox" id="check_all"/>
							</th>
							<th>#</th>
							<th>empName</th>
							<th>gender</th>
							<th>email</th>
							<th>deptName</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					
					</tbody>
		
				</table>
			</div>
		</div>
		<!-- 显示分页信息 -->
		<div class="row">
			<!--分页文字信息  -->
			<div class=col-md-6 id="page_info_area">	
			</div>
			<!--分页条信息  -->
			<div class=col-md-6 id="page_nav_area">
				
			</div>
		</div>
	</div>
	<script type="text/javascript">
	
		//定义一个全局变量，用于来到最后一页
		var totalRecord,currentPage;
	 	//页面加载完成以后，直接去发送一个ajax请求，要到分页数据
	 	$(function(){
	 		//去首页
	 		to_page(1);
	 	});
	 	
	 	function to_page(pn){
	 		$.ajax({
	 			url:"${APP_PATH}/emps",
	 			data:"pn="+pn,
	 			type:"get",
	 			success:function(result){
	 				//console.log(result);
	 				//1.解析并显示员工信息
	 				build_emps_table(result);
	 				//2.解析并显示分页信息
	 				build_page_info(result)
	 				//3.解析显示分页条
	 				build_page_nav(result)
	 			}
	 		});
	 	}
	 	
	 	function build_emps_table(result){
	 		//清空表格
	 		$("#emps_table tbody").empty();
	 		
	 		var emps=result.extend.pageInfo.list;
	 		$.each(emps,function(index,item){
	 			//alert(item.empName);
	 			var checkBoxTd=$("<td><input type='checkbox' class='check_item'/></td>");
	 			var empIdTd = $("<td></td>").append(item.empId);
	 			var empNameTd = $("<td></td>").append(item.empName);
	 			var genderTd = $("<td></td>").append(item.gender=='M'?"男":"女");
	 			var emailTd=$("<td></td>").append(item.email);
	 			var deptNameTd=$("<td></td>").append(item.department.deptName);
	 			
	 			/* 
	 				<button class=btn-primary btn-sm>
						<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
						编辑
					</button>
	 			*/
	 			var editBtn=$("<button></button>").addClass("btn-primary btn-sm edit_btn")
	 							.append("<span></span>").addClass("glyphicon glyphicon-pencil")
	 								.append("编辑");
	 			//为编辑按钮添加一个自定义的属性，表示当前员工的id
	 			editBtn.attr("edit-id",item.empId);
	 			var delBtn=$("<button></button>").addClass("btn-danger btn-sm delete_btn")
								.append("<span></span>").addClass("glyphicon glyphicon-trash")
									.append("删除");
	 			//为删除按钮添加一个自定义的属性，表示当前删除员工的id
	 			delBtn.attr("del-id",item.empId);
	 			
	 			var btnTd =$("<td></td>").append(editBtn).append(" ").append(delBtn);
	 			//append方法执行完成后返回的还是原来的元素
	 			$("<tr></tr>").append(checkBoxTd)
	 			.append(empIdTd)
	 			.append(empNameTd)
	 			.append(genderTd)
	 			.append(emailTd)
	 			.append(deptNameTd)
	 			.append(btnTd)
	 			.appendTo("#emps_table tbody")
	 		})
	 	}
	 	//解析显示分页信息
	 	function build_page_info(result){
	 		$("#page_info_area").empty();
	 		
	 		$("#page_info_area").append("当前"+result.extend.pageInfo.pageNum+"页,总共"+
	 				result.extend.pageInfo.pages+"页,总"+
	 				result.extend.pageInfo.total+"条记录");
	 		
	 		totalRecord=result.extend.pageInfo.total;
	 		currentPage=result.extend.pageInfo.pageNum;
	 	}
	 	//解析显示分页条，点击分页要能去下一页
	 	function build_page_nav(result){
	 		$("#page_nav_area").empty();
	 		
	 		//page_nav_area
	 		var ul=$("<ul></ul>").addClass("pagination");
	 		
	 		var firstPageLi=$("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
	 		var prePageLi=$("<li></li>").append($("<a></a>").append("&laquo;"));
	 		
	 		//没有前一页的话，前一页和首页标识不可点击，而且不添加点击事件
	 		if(result.extend.pageInfo.hasPreviousPage == false){
	 			firstPageLi.addClass("disabled");
	 			prePageLi.addClass("disabled");
	 		}else{
	 			//为元素添加点击翻页的事件
		 		firstPageLi.click(function(){
		 			to_page(1);
		 		});
		 		prePageLi.click(function(){
		 			to_page(result.extend.pageInfo.pageNum-1);
		 		});
	 		}
	 		
	 		var nextPageLi=$("<li></li>").append($("<a></a>").append("&raquo;"));
	 		var lastPageLi=$("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
	 		
	 		//没有下一页的话，后一页和末页标识不可点击
	 		if(result.extend.pageInfo.hasNextPage == false){
	 			nextPageLi.addClass("disabled");
	 			lastPageLi.addClass("disabled");
	 		}else{
	 			//为元素添加点击翻页的事件
		 		lastPageLi.click(function(){
		 			to_page(result.extend.pageInfo.pages);
		 		});
		 		nextPageLi.click(function(){
		 			to_page(result.extend.pageInfo.pageNum+1);
		 		});
		 		
	 		}

	 		//添加首页和前一页
	 		ul.append(firstPageLi).append(prePageLi);
	 		
	 		//构建1,2,3等页码信息
	 		$.each(result.extend.pageInfo.navigatepageNums,function(index,item){
	 			var numLi=$("<li></li>").append($("<a></a>").append(item));
	 			//添加活动标识
	 			if(result.extend.pageInfo.pageNum ==item){
	 				numLi.addClass("active");
	 			}
	 			//添加点击事件
	 			numLi.click(function(){
	 				to_page(item);
	 			});
	 			ul.append(numLi);
	 		});
	 		//添加末页和后一页的提示
	 		ul.append(nextPageLi).append(lastPageLi);
	 		var navEle=$("<nav></nav>").append(ul);
	 		navEle.appendTo("#page_nav_area");
	 	}
	 	
	 	//清空表单数据和样式
	 	function reset_form(ele){
	 		$(ele)[0].reset();
	 		
	 		//清空表单样式
	 		//找到元素下的所有子元素，如果有"has-success has-error"，就清除掉
	 		$(ele).find("*").removeClass("has-success has-error");
	 		$(ele).find(".help-block").text("");
	 	}
	 	
	 	//点击新增按钮，弹出模态框
	 	$("#emp_add_btn").click(function(){
	 		
	 		//清除表单数据：包含表单的数据和表单的样式
	 		reset_form("#empAddModal form");
	 		
	 		//发送ajax请求，查出部门信息，显示在下拉列表中
	 		getDepts("#dept_add_select");
	 		//弹出模态框
	 		$("#empAddModal").modal({
	 			backdrop:"static"
	 		});
	 	});
	 	//查出所有的部门信息，并显示在下拉列表中
	 	function getDepts(ele){
	 		$(ele).find("option").remove();
	 		$.ajax({
	 			url:"${APP_PATH}/depts",
	 			type:"get",
	 			success:function(result){
	 				//console.log(result);
	 				//{"code":100,"msg":"处理成功","extend":{"depts":[{"deptId":1,"deptName":"开发部"},{"deptId":2,"deptName":"测试部"}]}}
	 				//显示部门信息在下拉列表中
	 				//$("#dept_add_select").append()
	 				//此处function函数省略了index，item，可以用this代替item
	 				$.each(result.extend.depts,function(){
	 					var optionEle=$("<option></option>").append(this.deptName).attr("value",this.deptId);
	 					optionEle.appendTo(ele);
	 				});
	 				
	 			}
	 		});
	 	}
	 	
	 	//校验表单数据
	 	function validate_add_form(){
	 		//拿到要校验的数据，使用正则表达式
	 		var empName=$("#empName_add_input").val();
	 		var regName=/(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
			if(!regName.test(empName)){
				//alert("用户名可以是2-5位中文或者6-16位英文和数字、-、_、的组合");
				show_validate_msg("#empName_add_input","error","用户名可以是2-5位中文或者6-16位英文和数字、-、_、的组合");
				return false;
			}else{
				show_validate_msg("#empName_add_input","success","");
			}
			//校验邮箱信息
			var email=$("#email_add_input").val();
			var regEmail=/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if(!regEmail.test(email)){
				//alert("邮箱格式不正确");
				show_validate_msg("#email_add_input","error","邮箱格式不正确");
				return false;
			}else{
				show_validate_msg("#email_add_input","success","");
			}
			return true;
	 	}
	 	//显示校验结果的提示信息
	 	function show_validate_msg(ele,status,msg){
	 		//清除当前元素的校验状态
	 		$(ele).parent().removeClass("has-success has-error");
	 		$(ele).next("span").text("");
	 		if("success"==status){	
	 			$(ele).parent().addClass("has-success");
				$(ele).next("span").text(msg);
	 			
	 		}else if("error"==status){
	 			$(ele).parent().addClass("has-error");
				$(ele).next("span").text(msg);
				
	 		}
	 	}
	 	//校验用户名是否可用，防重
	 	$("#empName_add_input").change(function(){
	 		//发送ajax请求校验用户名是否可用
	 		var empName=this.value;
	 		$.ajax({
	 			url:"${APP_PATH}/checkuser",
	 			data:"empName="+empName,
	 			type:"POST",
	 			success:function(result){
	 				if(result.code==100){
	 					show_validate_msg("#empName_add_input","success","用户名可用");
	 					//给保存按钮设置一个属性值，点击保存按钮时用
	 					$("#emp_save_btn").attr("ajax-va","success");
	 				}else{
	 					show_validate_msg("#empName_add_input","error",result.extend.vamsg);
	 					$("#emp_save_btn").attr("ajax-va","error");
	 				}
	 			}
	 		});
	 	});
	 	
	 	$("#emp_save_btn").click(function(){
	 		
	 		//1.对要提交给服务器的数据进行校验
	 		if(!validate_add_form()){
	 			return false;
	 		}  
	 		//2.判断之前的ajax用户校验是否成功
	 		if($(this).attr("ajax-va")=="error"){
	 			return false;
	 		}
	 		
	 		//3.将模态框中的表单数据提交给服务器进行保存
	 		
	 		//"#empAddModal form" 这样写就不用给表单数据起id了，因为只有一个表单
	 		//alert($("#empAddModal form").serialize());可以序列化表单数据
	 		$.ajax({
	 			url:"${APP_PATH}/emp",
	 			type:"POST",
	 			data:$("#empAddModal form").serialize(),
	 			success:function(result){
	 				//alert(result.msg);
	 				if(result.code==100){
	 					//员工信息保存成功后，要关闭模态框并来到最后一页
		 				$("#empAddModal").modal('hide');
		 				
		 				//发送ajax请求，显示最后一页数据（因为在mybtis配置中设置了reasonable）
		 				//如果请求超过最大的页数，会请求最大达页数
		 				to_page(totalRecord);
	 				}else{
	 					//后端校验失败，显示字段信息
	 					//console.log(result);
	 					//有哪个字段的错误信息，就显示哪个字段的
	 					if(undefined != result.extend.errorFields.email){
	 						show_validate_msg("#email_add_input","error",result.extend.errorFields.email);
	 					}
	 					if(undefined != result.extend.errorFields.empName){
	 						show_validate_msg("#empName_add_input","error",result.extend.errorFields.empName);
	 					}
	 				}
	 				
	 			}
	 		}); 
	 	});
	 	
	 	//为修改按钮添加点击事件
	 	$(document).on("click",".edit_btn",function(){
	 		//alert("edit");
	 	
	 		//1.查出部门信息，并显示部门列表
	 		getDepts("#dept_update_select");
	 		
	 		//2.查出员工信息
	 		getEmp($(this).attr("edit-id"));
	 		
	 		//3.把员工的id传递给模态框的更新按钮
	 		$("#emp_update_btn").attr("edit-id",$(this).attr("edit-id"));
	 		
	 		//弹出模态框
	 		$("#empUpdateModal").modal({
	 			backdrop:"static"
	 		});
	 		
	 		
	 	});
	 	function getEmp(id){
	 		$.ajax({
	 			url:"${APP_PATH}/emp/"+id,
	 			type:"GET",
	 			success:function(result){
	 				//console.log(result);
	 				var empData=result.extend.emp;
	 				$("#empName_update_static").text(empData.empName);
	 				$("#email_update__input").val(empData.email);
	 				$("#email_update__input").val(empData.email);
	 				$("#empUpdateModal input[name=gender]").val([empData.gender]);
	 				$("#empUpdateModal select").val([empData.dId]);
	 			}
	 		});
	 	}
	 	//点击更新，更新员工信息
	 	$("#emp_update_btn").click(function(){
	 		//验证邮箱是否合法
	 		//1.校验邮箱信息
			var email=$("#email_update__input").val();
			var regEmail=/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if(!regEmail.test(email)){
				show_validate_msg("#email_update__input","error","邮箱格式不正确");
				return false;
			}else{
				show_validate_msg("#email_update__input","success","");
			}
			//2.发送ajax请求，保存更新的员工数据;
			//客户端不可以直接发送put请求的，需要在服务器配置一个过滤器支持/或者修改data数据
			/* $.ajax({
				url:"${APP_PATH}/emp/"+$(this).attr("edit-id"),
				type:"POST",
				data:$("#empUpdateModal form").serialize()+"&_method=PUT",
				success:function(result){
					alert(result.msg);
				}
			}); */
			
			$.ajax({
				url:"${APP_PATH}/emp/"+$(this).attr("edit-id"),
				type:"PUT",
				data:$("#empUpdateModal form").serialize(),
				success:function(result){
					//alert(result.msg);
					//1.关闭模态框
						$("#empUpdateModal").modal('hide');
					//2.回到本页面
					to_page(currentPage);
				}
			});
	 	});
	 	
	 	//单个删除
	 	$(document).on("click",".delete_btn",function(){
	 		//1.弹出是否确认删除对话框
	 		//alert($(this).parents("tr").find("td:eq(2)").text());
	 		var empName=$(this).parents("tr").find("td:eq(2)").text();
	 		var empId=$(this).attr("del-id");
	 		if(confirm("确认删除【"+empName+"】吗？")){
	 			//确认，删除即可
	 			$.ajax({
	 				url:"${APP_PATH}/emp/"+empId,
	 				type:"DELETE",
	 				success:function(result){
	 					//alert(result.msg);
	 					//回到本页
	 					to_page(currentPage);
	 				}
	 			});
	 		}
	 	});
	 	
	 	//完成全选全不选功能
	 	$("#check_all").click(function(){
	 		//建议：
	 		//$(this).attr("checked") 通过attr获取自定义的属性的值
	 		//$(this).prop("checked") 通过prop获取原生dom的属性的值
	 		//alert($(this).prop("checked"));
	 		
	 		//设置所有带有check_item 的属性的元素的checked 的属性值与全选一致
	 		$(".check_item").prop("checked",$(this).prop("checked"));
	 	});
	 	
	 	$(document).on("click",".check_item",function(){
	 		//复选框被选中的个数是否等于复选框总的个数
	 		var flag =$(".check_item:checked").length==$(".check_item").length;
	 		$("#check_all").prop("checked",flag);
	 	});
	 	
	 	$("#emp_delete_all_btn").click(function(){
	 		var empNames="";
	 		var del_id_str="";
	 		
	 		$.each($(".check_item:checked"),function(){
	 			empNames += $(this).parents("tr").find("td:eq(2)").text()+",";
	 			del_id_str += $(this).parents("tr").find("td:eq(1)").text()+"-";
	 		});
	 		
	 		//去除empNames多余的","
	 		empNames = empNames.substring(0,empNames.length-1);
	 		//去除del_id_str多余的"-"
	 		del_id_str = del_id_str.substring(0,del_id_str.length-1);
	 		
	 		if(confirm("确认删除【"+empNames+"】吗？")){
	 			$.ajax({
	 				url:"${APP_PATH}/emp/"+del_id_str,
	 				type:"DELETE",
	 				success:function(result){
	 					alert(result.msg);
	 					to_page(currentPage);
	 				}
	 			});
	 		}
	 	});
	</script>

</body>
</html>