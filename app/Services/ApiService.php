<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

class ApiService
{
    protected $timeout;

    public function __construct($timeout = 30)
    {
        $this->timeout = $timeout; // timeout in seconds
    }

    /**
     * Send GET request to external API.
     */
    public function get($url, $params = [], $headers = [])
    {
        return Http::withHeaders($headers)
            ->timeout($this->timeout)
            ->get($url, $params);
    }

    /**
     * Send POST request to external API.
     */
    public function post($url, $data = [], $headers = [])
    {
        return Http::withHeaders($headers)
            ->timeout($this->timeout)
            ->post($url, $data);
    }

    /**
     * Send PUT request to external API.
     */
    public function put($url, $data = [], $headers = [])
    {
        return Http::withHeaders($headers)
            ->timeout($this->timeout)
            ->put($url, $data);
    }

    /**
     * Send DELETE request to external API.
     */
    public function delete($url, $data = [], $headers = [])
    {
        return Http::withHeaders($headers)
            ->timeout($this->timeout)
            ->delete($url, $data);
    }
}
