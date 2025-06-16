import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:yalla_rehla/features/owner/Screens/sign_in_admin.dart';

import '../../features/owner/Screens/RoleSelectionPage.dart';
import '../../features/owner/pages/EditInformationPage.dart';
import '../../features/owner/pages/HomePage.dart';
import '../../features/owner/pages/PersonalInformationPage.dart';
import '../../features/owner/pages/onboardingScreen1.dart';
import '../../features/owner/pages/onboardingScreen2.dart';
import '../../features/owner/pages/onboardingScreen3.dart';
import '../../features/owner/pages/sign_in.dart';
import '../../features/user/auth/ui/logic/forgot_password_cubit.dart';
import '../../features/user/auth/ui/logic/login_cubit.dart';
import '../../features/user/auth/ui/logic/register_cubit.dart';
import '../../features/user/auth/ui/screens/forgot_password_screen.dart';
import '../../features/user/auth/ui/screens/login_screen.dart';
import '../../features/user/auth/ui/screens/register_screen.dart';
import '../../features/user/booking/ui/logic/bookings_cubit.dart';
import '../../features/user/booking/ui/screens/flight_booking_screen.dart';
import '../../features/user/booking/ui/screens/my_bookings_screen.dart';
import '../../features/user/chat/ui/screens/chat_bot_screen.dart';
import '../../features/user/favorites/ui/logic/favorites_cubit.dart';
import '../../features/user/favorites/ui/screens/favorites_screen.dart';
import '../../features/user/home/data/model/destination_model.dart';
import '../../features/user/home/ui/logic/home_cubit.dart';
import '../../features/user/home/ui/screens/home_screen.dart';
import '../../features/user/home/ui/screens/host_screen.dart';
import '../../features/user/profile/ui/logic/profile_cubit.dart';
import '../../features/user/profile/ui/screens/Profile_edit_screen.dart';
import '../../features/user/profile/ui/screens/profile_view_screen.dart';
import 'routes.dart';

final sl = GetIt.instance;

class AppRouter {
  static Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      //! User Routes

      case Routes.travelerLogin:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<LoginCubit>(),
            child: const LoginScreen(),
          ),
        );

      case Routes.register:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<RegisterCubit>(),
            child: const RegisterScreen(),
          ),
        );

      case Routes.forgotPassword:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<ForgotPasswordCubit>(),
            child: const ForgotPasswordScreen(),
          ),
        );

      case Routes.host:
        return MaterialPageRoute(builder: (_) => const HostScreen());

      case Routes.home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<HomeCubit>(),
            child: const HomeScreen(),
          ),
        );

      case Routes.chatBot:
        return MaterialPageRoute(builder: (_) => const ChatBotScreen());

      case Routes.flightBooking:
        return MaterialPageRoute(
          builder: (context) {
            final destination = arguments as DestinationModel;
            return BlocProvider.value(
              value: sl<BookingsCubit>(),
              child: FlightBookingScreen(destination: destination),
            );
          },
        );

      case Routes.myBookings:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: sl<BookingsCubit>(),
            child: const MyBookingsScreen(),
          ),
        );

      case Routes.favorites:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: sl<FavoritesCubit>(),
            child: const FavoritesScreen(),
          ),
        );

      case Routes.profile:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<ProfileCubit>(),
            child: const ProfileViewScreen(),
          ),
        );

      case Routes.editProfile:
        return MaterialPageRoute(
          builder: (context) {
            return BlocProvider.value(
              value: sl<ProfileCubit>(),
              child: const ProfileEditScreen(),
            );
          },
        );

      //! Onboarding & Role Selection Routes
      case Routes.onboarding1:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen1());

      case Routes.onboarding2:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen2());

      case Routes.onboarding3:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen3());

      case Routes.roleSelection:
        return MaterialPageRoute(builder: (_) => const RoleSelectionPage());

      case Routes.adminLogin:
        return MaterialPageRoute(builder: (_) => const SignIn1());

      case Routes.businessLogin:
        return MaterialPageRoute(builder: (_) => const SignIn());

      case Routes.adminHome:
        return MaterialPageRoute(builder: (_) => const HomePage());

      //! Owner Screens
      case Routes.information:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => EditInformationPage(
            name: args['name'] ?? '',
            email: args['email'] ?? '',
            phone: args['phone'] ?? '',
            birthDate: '',
            profilePicture: '',
            gender: '',
          ),
        );

      case Routes.personalInformation:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => PersonalInformationPage(
            email: args['email'] ?? '',
            phone: args['phone'] ?? '',
            firstName: '',
            lastName: '',
            userName: '',
            birthDate: '',
            gender: '',
          ),
        );

      // default:
      //   return MaterialPageRoute(
      //     builder:
      //         (_) => Scaffold(
      //           appBar: AppBar(title: const Text('Error')),
      //           body: const Center(
      //             child: Text(
      //               'Page not found!',
      //               style: TextStyle(
      //                 fontSize: 20,
      //                 fontWeight: FontWeight.bold,
      //                 color: Colors.red,
      //               ),
      //             ),
      //           ),
      //         ),
      //   );
    }
    return null;
  }
}
