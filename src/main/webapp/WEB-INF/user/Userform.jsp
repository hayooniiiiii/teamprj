<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>회원 가입 - Industrious by TEMPLATED</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="/assets/css/main.css">
</head>
<body>
<header id="header">
    <a class="logo" href="index.html">비트캠프</a>
    <nav>
        <a href="#menu">Menu</a>
    </nav>
</header>

<div id="heading">
    <h1>회원 가입</h1>
</div>

<section id="main" class="wrapper">
    <form action="./insert" method="post" enctype="multipart/form-data">
        <div class="inner">
            <div class="content">
                <h2>계정 생성</h2>
                <div class="row gtr-uniform">
                    <div class="col-6 col-12-xsmall">
                        <label for="userName">이름 입력</label>
                        <input type="text" name="userName" id="userName" placeholder="이름" required>
                    </div>
                    <div class="col-6 col-12-xsmall">
                        <label for="userEmail">이메일</label>
                        <input type="text" name="userEmail" id="userEmail" placeholder="이메일" required>
                    </div>
                    <div class="col-6 col-12-xsmall">
                        <label for="userId">아이디</label>
                        <input type="text" name="userId" id="userId" placeholder="아이디" required>
                        <br>
                        <input type="button" value="중복 확인" id="btncheckid">
                    </div>
                    <div class="col-6 col-12-xsmall">
                        <label for="userResidentno">주민등록번호</label>
                        <div style="display: flex; gap: 5px;">
                            <input type="text" name="userResidentno" id="userResidentno" placeholder="6자리" required style="flex-grow: 1;" maxlength="6">
                            -
                            <input type="password" name="userResidentPass" id="userResidentPass" placeholder="7자리" required style="flex-grow: 1;" maxlength="7">
                        </div>
                    </div>
                    <div class="col-6 col-12-xsmall">
                        <label for="userPassword">비밀번호</label>
                        <input type="password" name="userPassword" id="userPassword" placeholder="비밀번호" required>
                    </div>
                    <div class="col-6 col-12-xsmall">
                        <label for="userPasswordConfirm">비밀번호 확인</label>
                        <input type="password" name="userPasswordConfirm" id="userPasswordConfirm" placeholder="비밀번호 확인" required>
                    </div>
                    <div class="col-6 col-12-xsmall">
                        <label for="userPostal">우편번호</label>
                        <button id="searchPostalCode" type="button">우편번호찾기</button>
                        <br><br>
                        <input type="text" name="userPostal" id="userPostal" placeholder="우편번호">
                        <br>
                        <input type="text" name="userAddr1" id="userAddr1" placeholder="기본 주소">
                        <br>
                        <input type="text" name="userAddr2" id="userAddr2" placeholder="상세 주소">
                        <br>
                        <input type="text" name="extraAddr" id="extraAddr" placeholder="참고 항목">
                    </div>
                    <div class="col-6 col-12-xsmall">
                        <label for="userCategory">가입 카테고리</label>
                        <select name="userCategory" id="userCategory">
                            <option value="0">학생</option>
                            <option value="2">관리자</option>
                        </select>
                    </div>
                    <div class="col-12">
                        <ul class="actions">
                            <li><input type="submit" value="가입하기" class="primary" onclick="return check();"></li>
                            <li><input type="reset" value="다시 쓰기"></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </form>
</section>

<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<script src="assets/js/jquery.min.js"></script>
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<script>
    $(document).ready(function() {
        let jungbok = false;

        $("#btncheckid").click(function() {
            if ($("#userId").val() == '') {
                alert("가입할 아이디를 입력해주세요");
                return;
            }

            $.ajax({
                type: "get",
                dataType: "json",
                url: "./idcheck",
                data: { "searchid": $("#userId").val() },
                success: function(data) {
                    if (data.count == 0) {
                        alert("가입 가능한 아이디입니다");
                        jungbok = true;
                    } else {
                        alert("이미 가입되어있는 아이디입니다");
                        jungbok = false;
                        $("#userId").val("");
                    }
                }
            });
        });

        //아이디를 입력시 다시 중복확인을 누르도록 중복변수를 초기화
        $("#userId").keyup(function() {
            jungbok = false;
        });

        function check() {
            if (!jungbok) {
                alert("아이디 중복확인을 해주세요");
                return false; // false 반환시 action 실행을 안함
            }
            return true;
        }

        document.getElementById("searchPostalCode").addEventListener("click", function() {
            searchAddr();
        });

        function searchAddr() {
            new daum.Postcode({
                oncomplete: function(data) {
                    var addr = '';
                    var extraAddr = '';

                    if (data.userSelectedType === 'R') {
                        addr = data.roadAddress;
                    } else {
                        addr = data.jibunAddress;
                    }

                    if (data.userSelectedType === 'R') {
                        if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
                            extraAddr += data.bname;
                        }
                        if (data.buildingName !== '' && data.apartment === 'Y') {
                            extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                        }
                        if (extraAddr !== '') {
                            extraAddr = '(' + extraAddr + ')';
                        }
                        document.getElementById("extraAddr").value = extraAddr;
                    } else {
                        document.getElementById("userAddr2").value = '';
                    }

                    document.getElementById('userPostal').value = data.zonecode;
                    document.getElementById("userAddr1").value = addr;
                    document.getElementById("userAddr2").focus();
                }
            }).open();
        }
    });
</script>
</body>
</html>
