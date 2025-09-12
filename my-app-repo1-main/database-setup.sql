-- School Directory Database Setup
-- Run this SQL in your Supabase SQL Editor

-- Create schools table
CREATE TABLE IF NOT EXISTS public.schools (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    city TEXT NOT NULL,
    state TEXT NOT NULL,
    contact TEXT NOT NULL,
    image TEXT DEFAULT '',
    email_id TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Create storage bucket for school images
INSERT INTO storage.buckets (id, name, public) 
VALUES ('school-images', 'school-images', true)
ON CONFLICT (id) DO NOTHING;

-- Enable RLS on schools table
ALTER TABLE public.schools ENABLE ROW LEVEL SECURITY;

-- Create policy to allow public read access to schools
CREATE POLICY "Public can view schools" ON public.schools
FOR SELECT USING (true);

-- Create policy to allow public insert access to schools
CREATE POLICY "Public can insert schools" ON public.schools
FOR INSERT WITH CHECK (true);

-- Create policy to allow public uploads to school-images bucket
CREATE POLICY "Public can upload school images" ON storage.objects
FOR INSERT WITH CHECK (bucket_id = 'school-images');

-- Create policy to allow public read access to school-images bucket
CREATE POLICY "Public can view school images" ON storage.objects
FOR SELECT USING (bucket_id = 'school-images');