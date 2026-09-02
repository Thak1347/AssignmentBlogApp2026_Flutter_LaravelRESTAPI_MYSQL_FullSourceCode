<?php

namespace Database\Factories;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Post>
 */
class PostFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $titles = [
            'The Future of Technology',
            'How to Learn Programming in 2026',
            '10 Tips for Better Productivity',
            'Understanding AI and Machine Learning',
            'The Art of Minimalist Living',
            'Building Scalable Web Applications',
            'Mastering Flutter Development',
            'The Power of Clean Code',
            'Digital Marketing Strategies',
            'Remote Work Best Practices',
            'Why You Should Start Coding Today',
            'The Importance of Mental Health in Tech',
        ];

        $contents = [
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
            'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
            'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
            'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.',
            'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum.',
            'Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates.',
        ];

        return [
            'user_id' => User::factory(),
            'title' => $this->faker->randomElement($titles),
            'content' => $this->faker->randomElement($contents) . ' ' .
                $this->faker->randomElement($contents),
            'image' => null,
        ];
    }
}