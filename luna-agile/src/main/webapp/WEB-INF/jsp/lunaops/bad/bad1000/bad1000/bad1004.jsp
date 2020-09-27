<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="kt-portlet kt-portlet--mobile">
	<input type="hidden" name="stmTypeCd" id="stmTypeCd" value="${param.stmTypeCd }" /> 
	<input type="hidden" id="stmDsTypeCd" name="stmDsTypeCd" value='${param.stmDsTypeCd}'/>
	<input type="hidden" name="prjGrpId" id="prjGrpId" value="${param.prjGrpId }" /> 
	<input type="hidden" name="prjId" id="prjId" value="${param.prjId }" /> 
	<input type="hidden" name="menuId" id="menuId" value="${param.menuId }" /> 
	<input type="hidden" name="badNum" id="badNum" value="${param.badNum }" /> 
	<input type="hidden" name="badId" id="badId" value="${param.badId }" />
	<input type="hidden" name="searchTarget" id="searchTarget" value='${param.searchTarget }' />
	<input type="hidden" name="backPageYn" id="backPageYn" value="${param.backPageYn }" /> 
	<div class="kt-portlet__body">
		<div class="kt-align-center">
			<span>
				이 글은 비밀글입니다.<br>
				비밀번호를 입력하세요.
			</span>
			<div class="input-group kt-margin-t-10">
				<input type="password" class="form-control" name="badPwInput" id="badPwInput" regexstr="^[a-z0-9]{4,12}$" required>
				<div class="input-group-append">
					<button class="btn btn-brand" name="pwCheckBtn" id="pwCheckBtn">확인</button>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- begin page script -->
<script>
"use strict";

var OSLBad1004Popup = function () {
	$("#badPw").focus();
	
    var documentSetting = function () {
    	//비밀번호 확인 버튼 클릭 했을 때
    	$("#pwCheckBtn").click(function(){
    		selectPwInfo();
    	});
    	//비밀번호 입력 후 엔터 쳤을 때
    	$("#badPwInput").on("keypress", function(e){
    		if(e.key == "Enter"){
    			$("#pwCheckBtn").click();		
    		}
    	});
    }
    
    var selectPwInfo = function(){
    	var data = {
   			"badPw" : $("#badPwInput").val(),
   			"badId" : $("#badId").val(),
   			"menuId" : $("#menuId").val(),
   			"prjGrpId" : $("#prjGrpId").val(),
   			"prjId" : $("#prjId").val(),
    	}
    	
    	var ajaxObj = new $.osl.ajaxRequestAction(
    			{"url":"<c:url value='/bad/bad1000/bad1000/selectBad1004PwInfoAjax.do'/>"}
				, data);
    	
    	//ajax 전송 성공 함수
    	ajaxObj.setFnSuccess(function(data){
    		if(data.errorYn == "Y"){
				$.osl.alert(data.message,{type: 'error'});
				//모달 창 닫기
				$.osl.layerPopupClose();
			}else{
				var pwCheck = data.resultPwCheck;
				//비밀번호가 일치하는 경우
				if(pwCheck == "Y"){
					var goData = {
							"badNum" :  $("#badNum").val(),
							"badId" : $("#badId").val(),
				   			"menuId" : $("#menuId").val(),
				   			"prjGrpId" : $("#prjGrpId").val(),
				   			"prjId" : $("#prjId").val(),
				   			"searchTarget" : $("#searchTarget").val(),
				   			"badHit" : true,
					};
					var goOptions = {
							modalTitle: "게시글 상세보기",
							closeConfirm: false,
							modalSize: "xl",
						};
					var backPageYn = $("#backPageYn").val();

					//현재 비밀번호 창 닫기
					$.osl.layerPopupClose();
					
					fileUploadObj.reset();
					
					//미리 열려진 게시글 팝업이 없을 경우
					if(backPageYn == "N"){
						var stmTypeCd = $("#stmTypeCd").val();
						//해당 게시글 팝업 열기
						if(stmTypeCd == "01" || stmTypeCd == "02"){
							$.osl.layerPopupOpen('/bad/bad1000/bad1000/selectBad1001View.do',goData,goOptions);
						}else{
							$.osl.layerPopupOpen('/bad/bad1000/bad1000/selectBad1007View.do',goData,goOptions);
						}
					}
				}else{
					$.osl.alert("비밀번호가 틀렸습니다. 다시 입력하세요." , {"type" : "warning"});
					$("#badPwInput").val("");
					$("#badPwInput").focus;
				}
			}
    	});
    	//AJAX 전송
		ajaxObj.send();
    }
    
    return {
        init: function() {
        	documentSetting();
        }
    };
}();

$.osl.ready(function(){
	OSLBad1004Popup.init();
});
</script>