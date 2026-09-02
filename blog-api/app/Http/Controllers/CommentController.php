<?php

namespace App\Http\Controllers;

use App\Models\Post;
use App\Models\Comment;
use Illuminate\Http\Request;

class CommentController extends Controller
{
    public function index($postId)
    {
        $post = Post::findOrFail($postId);
        $comments = $post->comments()->with('user')->get();

        return response()->json($comments, 200);
    }

    public function store(Request $request, $postId)
    {
        if (!$request->user()) {
            return response()->json(['message' => 'Unauthenticated.'], 401);
        }

        $request->validate([
            'content' => 'required|string|max:1000',
        ]);

        $post = Post::findOrFail($postId);

        $comment = Comment::create([
            'post_id' => $post->id,
            'user_id' => $request->user()->id,
            'content' => $request->content,
        ]);

        return response()->json([
            'comment' => $comment->load('user'),
            'message' => 'Comment added successfully',
        ], 201);
    }

    public function destroy(Request $request, $id)
    {
        if (!$request->user()) {
            return response()->json(['message' => 'Unauthenticated.'], 401);
        }

        $comment = Comment::findOrFail($id);

        if ((int) $comment->user_id !== (int) $request->user()->id) {
            return response()->json(['message' => 'Unauthorized action.'], 403);
        }

        $comment->delete();

        return response()->json(['message' => 'Comment deleted successfully'], 200);
    }
}