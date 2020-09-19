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
				<button class="btn btn-primary">新增</button>
				<button class="btn btn-danger">删除</button>
			</div>
		</div>
		<!-- 显示表格数据  tr 表示表行	th表示表头-->
		<div class="row">
			<div class=col-md-12>
				<table class="table table-hover" id="emps_table">
					<thead>
						<tr>
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
	 			var editBtn=$("<button></button>").addClass("btn-primary btn-sm")
	 							.append("<span></span>").addClass("glyphicon glyphicon-pencil")
	 								.append("编辑");
	 			var delBtn=$("<button></button>").addClass("btn-danger btn-sm")
								.append("<span></span>").addClass("glyphicon glyphicon-trash")
									.append("删除");
	 			var btnTd =$("<td></td>").append(editBtn).append(" ").append(delBtn);
	 			//append方法执行完成后返回的还是原来的元素
	 			$("<tr></tr>").append(empIdTd)
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
	</script>

</body>
</html>