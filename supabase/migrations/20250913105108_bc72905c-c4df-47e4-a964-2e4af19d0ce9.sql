-- Drop existing restrictive policies
DROP POLICY IF EXISTS "Authenticated users can view all school data" ON public.schools;

-- Create policy to allow public read access to schools
CREATE POLICY "Public can view schools" ON public.schools
FOR SELECT USING (true);

-- Keep authenticated user policies for data management
CREATE POLICY "Authenticated users can view schools" ON public.schools
FOR SELECT TO authenticated USING (true);