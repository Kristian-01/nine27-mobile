<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;

Class AuthController extends Controller
{
    // Register a new user
    public function register(Request $request)
    {
        // Validate input
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|min:6',
        ]);

        // Create user
        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
        ]);

        return response()->json([
            'message' => 'User registered successfully',
            'user' => $user
        ], 201);
    }

    // Login existing user
    public function login(Request $request)
	{
		$request->validate([
			'email' => 'required|email',
			'password' => 'required',
			'remember' => 'sometimes|boolean',
		]);

		$credentials = $request->only('email', 'password');
		$remember = (bool) $request->boolean('remember');

		if (!$Auth::attempt($credentials, $remember)) {
			return response()->json(['message' => 'Invalid credentials'], 401);
		}

		$request->session()->regenerate();

		return response()->json([
			'message' => 'Login successful', 
			'user' => Auth::user(),
			'remember' => $remember,
		], 200);
	}
}
