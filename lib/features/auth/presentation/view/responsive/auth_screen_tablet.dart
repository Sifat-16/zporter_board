
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zporter_board/core/resource_manager/assets_manager.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';
import 'package:zporter_board/core/resource_manager/route_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_bloc.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_event.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_state.dart';

class AuthScreenTablet extends StatefulWidget {
  const AuthScreenTablet({super.key});

  @override
  State<AuthScreenTablet> createState() => _AuthScreenTabletState();
}

class _AuthScreenTabletState extends State<AuthScreenTablet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.black,
      body: Center(
        child: GestureDetector(
          onTap: (){
            context.read<AuthBloc>().add(GoogleSignInEvent());

          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: AppMargin.h12, vertical: AppMargin.v8),
            decoration: BoxDecoration(
              color: ColorManager.yellow.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(AppRadius.r4)
            ),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (BuildContext context, AuthState state) {



                if(state is GoogleSignInSuccess){
                  _onSuccessFulSignIn();
                }

                if(state is GoogleSignInFailure){
                  debug(data: "Google Signin error ${state.message}");
                }



              },
              builder: (context, state) {

                if(state is GoogleSignInProgress){
                  return SizedBox(
                    height: AppSize.s24, // Set proper height
                    width: AppSize.s24,  // Set proper width
                    child: CircularProgressIndicator(
                      color: ColorManager.white,
                      strokeWidth: 2, // Adjust thickness
                    ),
                  );
                }

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(AssetsManager.logo, height: AppSize.s24, width: AppSize.s24, color: ColorManager.white,),
                    SizedBox(width: AppSize.s14,),
                    Text("Login with Zporter", style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold
                    ))
                  ],
                );
              },
            ),
          ),
        ),
      ),

    );
  }

  void _onSuccessFulSignIn() {
    BotToast.showText(text: "Sign In Successful!");
    GoRouter.of(context).pushReplacementNamed(Routes.board);
  }

}
