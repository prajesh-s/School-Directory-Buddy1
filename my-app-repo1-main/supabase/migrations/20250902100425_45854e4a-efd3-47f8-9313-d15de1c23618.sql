-- Create schools table
CREATE TABLE public.schools (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  address TEXT NOT NULL,
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  contact TEXT NOT NULL,
  email_id TEXT NOT NULL,
  image TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE public.schools ENABLE ROW LEVEL SECURITY;

-- Create policies to allow public access (schools are public information)
CREATE POLICY "Allow public read access to schools" 
ON public.schools 
FOR SELECT 
USING (true);

CREATE POLICY "Allow public insert access to schools" 
ON public.schools 
FOR INSERT 
WITH CHECK (true);

CREATE POLICY "Allow public update access to schools" 
ON public.schools 
FOR UPDATE 
USING (true);

CREATE POLICY "Allow public delete access to schools" 
ON public.schools 
FOR DELETE 
USING (true);

-- Create storage bucket for school images
INSERT INTO storage.buckets (id, name, public) 
VALUES ('school-images', 'school-images', true);

-- Create storage policies for school images
CREATE POLICY "Public access to school images" 
ON storage.objects 
FOR SELECT 
USING (bucket_id = 'school-images');

CREATE POLICY "Anyone can upload school images" 
ON storage.objects 
FOR INSERT 
WITH CHECK (bucket_id = 'school-images');

CREATE POLICY "Anyone can update school images" 
ON storage.objects 
FOR UPDATE 
USING (bucket_id = 'school-images');

CREATE POLICY "Anyone can delete school images" 
ON storage.objects 
FOR DELETE 
USING (bucket_id = 'school-images');