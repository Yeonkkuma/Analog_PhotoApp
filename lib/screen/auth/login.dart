import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isEmailFilled = false;
  bool isPasswordFilled = false;

  @override
  void initState() {
    super.initState();

    idController.addListener(() {
      setState(() {
        isEmailFilled = idController.text.isNotEmpty;
      });
    });

    passwordController.addListener(() {
      setState(() {
        isPasswordFilled = passwordController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // 파이어베이스 추가 코드(...)
  Future<void> _login() async {
    final email = idController.text.trim();
    final password = passwordController.text.trim();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? '로그인에 실패했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFormFilled = isEmailFilled && isPasswordFilled;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 40.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "사진 동네",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFC2E19E),
                    ),
                  ),

                  const SizedBox(height: 50),

                  TextField(
                    controller: idController,
                    decoration: InputDecoration(
                      hintText: '아이디 입력',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 128, 128, 128),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 192, 192, 192),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.5,
                        ), // 클릭된 경우 테두리 색 ..
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: '비밀번호 입력',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 128, 128, 128),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.5,
                        ), // 클릭된 경우 테두리 색 ..
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: isFormFilled ? _login : null,
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0), // ← 그림자 제거
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((
                        Set<MaterialState> states,
                      ) {
                        if (states.contains(MaterialState.disabled)) {
                          return const Color(0xFFE0E0E0); // 비활성 상태 배경색
                        }
                        return const Color(0xFFDBEFC4); // 활성 상태 배경색
                      }),
                      foregroundColor: MaterialStateProperty.resolveWith<Color>((
                        Set<MaterialState> states,
                      ) {
                        if (states.contains(MaterialState.disabled)) {
                          return const Color.fromARGB(
                            255,
                            82,
                            82,
                            82,
                          ); // 비활성 텍스트 색
                        }
                        return Colors.black; // 활성 텍스트 색
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    child: const Text("로그인하기"),
                  ),

                  const SizedBox(height: 0),

                  // 로그인 버튼 아래에 삽입
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup'); // 회원가입 화면
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero, // 패딩 X
                          minimumSize: Size(0, 0),
                          overlayColor: Colors.transparent,
                        ),
                        child: const Text(
                          '회원가입',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Color.fromARGB(255, 128, 128, 128),
                          ),
                        ),
                      ),

                      Container(
                        width: 1,
                        height: 12, // 텍스트 높이에 맞게 조절
                        color: Colors.grey,
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                        ), // 좌우 간격 조절
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/find_id'); // 아이디 찾기 화면
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero, // 패딩 X
                          minimumSize: Size(0, 0),
                          overlayColor: Colors.transparent,
                        ),
                        child: const Text(
                          '아이디 찾기',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Color.fromARGB(255, 128, 128, 128),
                          ),
                        ),
                      ),

                      Container(
                        width: 1,
                        height: 12, // 텍스트 높이에 맞게 조절
                        color: Colors.grey,
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                        ), // 좌우 간격 조절
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/find_password',
                          ); // 비밀번호 찾기 화면
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero, // 패딩 X
                          minimumSize: Size(0, 0),
                          overlayColor: Colors.transparent,
                        ),
                        child: const Text(
                          '비밀번호 찾기',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Color.fromARGB(255, 128, 128, 128),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // 소셜 로그인 구분선
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "  or  ",
                          style: TextStyle(
                            color: Color.fromARGB(255, 112, 112, 112),
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 구글 로그인
                  OutlinedButton(
                    onPressed: () {
                      // 구글 로그인 API 호출 처리
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      side: BorderSide(
                        color: Color.fromARGB(255, 192, 192, 192),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // 콘텐츠 크기에 맞춰 정렬
                        children: [
                          // Image.asset(
                          //   'assets/images/google.png',
                          //   width: 20,
                          //   height: 20,
                          // ),
                          // const SizedBox(width: 7), // 이미지와 텍스트 사이 간격
                          const Text(
                            "Google로 시작하기",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 7),

                  // 마이크로소프트 로그인
                  OutlinedButton(
                    onPressed: () {
                      // 마이크로소프트 로그인 API 호출 처리
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      side: BorderSide(
                        color: Color.fromARGB(255, 192, 192, 192),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Image.asset(
                          //   'assets/images/kakao.png',
                          //   width: 20,
                          //   height: 20,
                          // ),
                          // const SizedBox(width: 12),
                          const Text(
                            "Mycrosoft로 시작하기",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
