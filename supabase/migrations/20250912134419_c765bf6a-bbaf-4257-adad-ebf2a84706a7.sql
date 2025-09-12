-- Fix security vulnerability: Protect sensitive school contact information
-- Remove existing public policies that expose all data
DROP POLICY IF EXISTS "Allow public read access to schools" ON public.schools;
DROP POLICY IF EXISTS "Allow public insert access to schools" ON public.schools;  
DROP POLICY IF EXISTS "Allow public update access to schools" ON public.schools;
DROP POLICY IF EXISTS "Allow public delete access to schools" ON public.schools;

-- Create secure RLS policies requiring authentication
CREATE POLICY "Authenticated users can view all school data" ON public.schools
FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can insert schools" ON public.schools
FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Authenticated users can update schools" ON public.schools
FOR UPDATE TO authenticated USING (true);

CREATE POLICY "Authenticated users can delete schools" ON public.schools
FOR DELETE TO authenticated USING (true);

-- Create a public function that returns schools without sensitive contact information
CREATE OR REPLACE FUNCTION public.get_public_schools()
RETURNS TABLE (
  id integer,
  name text,
  address text,
  city text,
  state text,
  image text,
  created_at timestamp with time zone
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT 
    id,
    name,
    address,
    city,
    state,
    image,
    created_at
  FROM public.schools
  ORDER BY created_at DESC;
$$;

-- Grant execute permission to anonymous users
GRANT EXECUTE ON FUNCTION public.get_public_schools() TO anon;