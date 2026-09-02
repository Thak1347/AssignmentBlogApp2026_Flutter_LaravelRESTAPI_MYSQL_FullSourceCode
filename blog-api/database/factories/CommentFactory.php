<?php

namespace Database\Factories;

use App\Models\Post;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Comment>
 */
class CommentFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $comments = [
            'Great post! Very informative.',
            'Thanks for sharing this!',
            'I completely agree with your points.',
            'This is exactly what I needed to read.',
            'Amazing content! Keep it up.',
            'Very helpful article, thank you!',
            'I learned a lot from this post.',
            'This changed my perspective.',
            'Well written and insightful.',
            'Looking forward to more posts like this!',
            'Great insights, thanks for sharing!',
            'Very useful information, will implement this.',
            'Excellent article, highly recommended.',
            'This is a fantastic read!',
            'I appreciate the effort you put into this.',
            'Thanks for the detailed explanation!',
            'This helped me understand the topic better.',
            'Brilliant post! Well done.',
            'I have a question about this topic.',
            'This is gold! Saving it for later.',
        ];

        return [
            'post_id' => Post::factory(),
            'user_id' => User::factory(),
            'content' => $this->faker->randomElement($comments),
        ];
    }
}