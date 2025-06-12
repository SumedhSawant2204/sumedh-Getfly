import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/side_drawer.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool otpSent = false;
  bool otpVerified = false;
  bool isLoading = false;
  bool showPassword = false;
  bool showConfirmPassword = false;
  String generatedOtp = "123456"; // Simulated OTP

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));
    
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    emailController.dispose();
    otpController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void sendOtp() async {
    if (emailController.text.isEmpty) {
      _showSnackBar("Please enter your email address", isError: true);
      return;
    }
    
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailController.text)) {
      _showSnackBar("Please enter a valid email address", isError: true);
      return;
    }

    setState(() => isLoading = true);
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      otpSent = true;
      isLoading = false;
    });

    _showSnackBar("OTP has been sent to your email", isError: false);
    _slideController.reset();
    _slideController.forward();
  }

  void verifyOtp() async {
    if (otpController.text.isEmpty) {
      _showSnackBar("Please enter the OTP", isError: true);
      return;
    }

    setState(() => isLoading = true);
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (otpController.text == generatedOtp) {
      setState(() {
        otpVerified = true;
        isLoading = false;
      });
      _showSnackBar("OTP verified successfully", isError: false);
      _slideController.reset();
      _slideController.forward();
    } else {
      setState(() => isLoading = false);
      _showSnackBar("Invalid OTP. Please try again", isError: true);
    }
  }

  void submitNewPassword() async {
    if (passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      _showSnackBar("Please fill in both password fields", isError: true);
      return;
    }
    
    if (passwordController.text.length < 6) {
      _showSnackBar("Password must be at least 6 characters long", isError: true);
      return;
    }
    
    if (passwordController.text != confirmPasswordController.text) {
      _showSnackBar("Passwords do not match", isError: true);
      return;
    }

    setState(() => isLoading = true);
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    _showSnackBar("Password changed successfully!", isError: false);

    setState(() {
      otpSent = false;
      otpVerified = false;
      isLoading = false;
      emailController.clear();
      otpController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
    });
    
    _slideController.reset();
    _slideController.forward();
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? const Color(0xFFD32F2F) : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          _buildStepIndicator(1, "Email", true),
          _buildStepLine(otpSent),
          _buildStepIndicator(2, "Verify", otpSent),
          _buildStepLine(otpVerified),
          _buildStepIndicator(3, "Reset", otpVerified),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, bool isActive) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF2A1070) : const Color(0xFFE5E7EB),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isActive
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : Text(
                      step.toString(),
                      style: TextStyle(
                        color: isActive ? Colors.white : const Color(0xFF9CA3AF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFF2A1070) : const Color(0xFF9CA3AF),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2A1070) : const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }

  Widget _buildFormCard(Widget child) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2A1070).withOpacity(0.08),
                  blurRadius: 24,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: const Color(0xFF2A1070).withOpacity(0.04),
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxWidth: 480),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onToggleVisibility,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1C1C1E),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword && !isPasswordVisible,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xFF5C5C5C),
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    Color? backgroundColor,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? const Color(0xFF2A1070),
          disabledBackgroundColor: const Color(0xFF9CA3AF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const SideDrawer(),
      appBar: AppHeader(scaffoldKey: _scaffoldKey),
      backgroundColor: const Color(0xFFF4F6F8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            
            // Header
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A1070).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      size: 40,
                      color: Color(0xFF2A1070),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Reset Password",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Follow the steps below to reset your password",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF5C5C5C),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Progress Indicator
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: _buildProgressIndicator(),
            ),
            
            const SizedBox(height: 24),
            
            // Form Card
            _buildFormCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step 1: Email
                  _buildTextField(
                    controller: emailController,
                    label: "Email Address",
                    hint: "Enter your registered email",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  if (!otpSent)
                    _buildButton(
                      text: "Send OTP",
                      onPressed: sendOtp,
                      isLoading: isLoading,
                    ),

                  // Step 2: OTP Verification
                  if (otpSent && !otpVerified) ...[
                    _buildTextField(
                      controller: otpController,
                      label: "Enter OTP",
                      hint: "Enter the 6-digit code sent to your email",
                      keyboardType: TextInputType.number,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: sendOtp,
                          child: const Text(
                            "Resend OTP",
                            style: TextStyle(
                              color: Color(0xFF2A1070),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Text(
                          "Code expires in 5:00",
                          style: TextStyle(
                            color: Color(0xFF5C5C5C),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    _buildButton(
                      text: "Verify OTP",
                      onPressed: verifyOtp,
                      isLoading: isLoading,
                      backgroundColor: const Color(0xFF5A4FCF),
                    ),
                  ],

                  // Step 3: New Password
                  if (otpVerified) ...[
                    _buildTextField(
                      controller: passwordController,
                      label: "New Password",
                      hint: "Enter your new password",
                      isPassword: true,
                      isPasswordVisible: showPassword,
                      onToggleVisibility: () {
                        setState(() => showPassword = !showPassword);
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    _buildTextField(
                      controller: confirmPasswordController,
                      label: "Confirm Password",
                      hint: "Re-enter your new password",
                      isPassword: true,
                      isPasswordVisible: showConfirmPassword,
                      onToggleVisibility: () {
                        setState(() => showConfirmPassword = !showConfirmPassword);
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    _buildButton(
                      text: "Update Password",
                      onPressed: submitNewPassword,
                      isLoading: isLoading,
                      backgroundColor: const Color(0xFF10B981),
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}