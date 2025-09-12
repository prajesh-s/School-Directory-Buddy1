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