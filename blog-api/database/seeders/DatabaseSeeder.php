<?php

namespace Database\Seeders;

use App\Models\Comment;
use App\Models\Post;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Create specific test users
        $user1 = User::create([
            'name' => 'Test User',
            'email' => 'test@example.com',
            'password' => Hash::make('password123'),
            'profile_image' => null,
        ]);

        $user2 = User::create([
            'name' => 'John Doe',
            'email' => 'john@example.com',
            'password' => Hash::make('password123'),
            'profile_image' => null,
        ]);

        // Create additional random users
        User::factory(5)->create();

        // Create posts for test users
        $allUsers = User::all();

        //
        $allUsers->each(function ($user) use ($allUsers) {
            Post::factory(3)->create([
                'user_id' => $user->id,
            ])->each(function ($post) use ($allUsers) {
                // Add 2-5 random comments to each post
                $commentCount = rand(2, 5);
                for ($i = 0; $i < $commentCount; $i++) {
                    Comment::factory()->create([
                        'post_id' => $post->id,
                        'user_id' => $allUsers->random()->id,
                    ]);
                }
            });
        });

        // Create specific post with comments for testing
        $testPost = Post::create([
            'user_id' => $user1->id,
            'title' => 'Welcome to the Blog App!',
            'content' => 'This is a sample post to test the application. Feel free to explore all features.',
            'image' => null,
        ]);

        Comment::create([
            'post_id' => $testPost->id,
            'user_id' => $user2->id,
            'content' => 'Great post! Looking forward to more content.',
        ]);

        Comment::create([
            'post_id' => $testPost->id,
            'user_id' => $user1->id,
            'content' => 'Thank you! More posts coming soon.',
        ]);

        $this->command->info('Database seeded successfully!');
        $this->command->info('Test account: test@example.com / password123');
        $this->command->info('Test account 2: john@example.com / password123');
    }
}