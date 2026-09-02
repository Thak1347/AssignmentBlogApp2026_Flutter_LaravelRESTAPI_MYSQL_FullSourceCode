<?php

namespace App\Http\Controllers;

use App\Models\Post;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class PostController extends Controller
{
    public function index()
    {
        $posts = Post::with(['user', 'comments.user'])
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json($posts, 200);
    }

    public function store(Request $request)
    {
        if (!$request->user()) {
            return response()->json(['message' => 'Unauthenticated.'], 401);
        }

        $request->validate([
            'title' => 'required|string|max:255',
            'content' => 'nullable|string',
            'image' => 'nullable|image|mimes:jpg,jpeg,png,webp|max:2048',
        ]);

        $imagePath = null;
        if ($request->hasFile('image')) {
            $image = $request->file('image');
            $filename = Str::random(40) . '.' . $image->getClientOriginalExtension();
            $imagePath = $image->storeAs('posts', $filename, 'public');
        }

        $post = Post::create([
            'user_id' => $request->user()->id,
            'title' => $request->title,
            'content' => $request->content,
            'image' => $imagePath,
        ]);

        return response()->json([
            'post' => $post->load(['user', 'comments.user']),
            'message' => 'Post created successfully',
        ], 201);
    }

    public function show($id)
    {
        $post = Post::with(['user', 'comments.user'])->findOrFail($id);
        return response()->json($post, 200);
    }

    // ADD THIS UPDATE METHOD
    public function update(Request $request, $id)
    {
        if (!$request->user()) {
            return response()->json(['message' => 'Unauthenticated.'], 401);
        }

        $post = Post::findOrFail($id);

        if ((int) $post->user_id !== (int) $request->user()->id) {
            return response()->json(['message' => 'Unauthorized action.'], 403);
        }

        $request->validate([
            'title' => 'required|string|max:255',
            'content' => 'nullable|string',
            'image' => 'nullable|image|mimes:jpg,jpeg,png,webp|max:2048',
        ]);

        // Update title and content
        $post->title = $request->title;
        $post->content = $request->content;

        // Handle image upload
        if ($request->hasFile('image')) {
            // Delete old image if exists
            if ($post->image) {
                Storage::disk('public')->delete($post->image);
            }

            $image = $request->file('image');
            $filename = Str::random(40) . '.' . $image->getClientOriginalExtension();
            $imagePath = $image->storeAs('posts', $filename, 'public');
            $post->image = $imagePath;
        }

        $post->save();

        return response()->json([
            'post' => $post->load(['user', 'comments.user']),
            'message' => 'Post updated successfully',
        ], 200);
    }

    public function destroy(Request $request, $id)
    {
        if (!$request->user()) {
            return response()->json(['message' => 'Unauthenticated.'], 401);
        }

        $post = Post::findOrFail($id);

        if ((int) $post->user_id !== (int) $request->user()->id) {
            return response()->json(['message' => 'Unauthorized action.'], 403);
        }

        if ($post->image) {
            Storage::disk('public')->delete($post->image);
        }

        $post->delete();

        return response()->json(['message' => 'Post deleted successfully'], 200);
    }

    public function uploadImage(Request $request)
    {
        $request->validate([
            'image' => 'required|image|mimes:jpg,jpeg,png,webp|max:2048',
        ]);

        $path = $request->file('image')->store('posts', 'public');

        return response()->json([
            'message' => 'Image uploaded successfully',
            'image_path' => $path,
        ], 200);
    }
}