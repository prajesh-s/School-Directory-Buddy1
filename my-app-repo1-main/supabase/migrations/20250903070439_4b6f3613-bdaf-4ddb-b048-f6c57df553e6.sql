-- Fix existing data and add validation constraints for schools table

-- Delete the problematic row that contains invalid data
DELETE FROM public.schools WHERE name = '0934';

-- Clean up any other problematic data
UPDATE public.schools 
SET 
  name = CASE 
    WHEN name ~ '^[0-9]+$' THEN 'School ' || name
    ELSE regexp_replace(name, '[^a-zA-Z\s\-\.&'']', '', 'g')
  END,
  city = regexp_replace(city, '[^a-zA-Z\s\-\.]', '', 'g'),
  state = regexp_replace(state, '[^a-zA-Z\s]', '', 'g'),
  contact = regexp_replace(contact, '[^\+0-9]', '', 'g')
WHERE 
  name !~ '^[a-zA-Z\s\-\.&'']+$' OR
  city !~ '^[a-zA-Z\s\-\.]+$' OR
  state !~ '^[a-zA-Z\s]+$';

-- Handle any fields that might become empty after cleanup
UPDATE public.schools 
SET name = 'Unknown School ' || id::text
WHERE trim(name) = '' OR name IS NULL;

UPDATE public.schools 
SET city = 'Unknown City'
WHERE trim(city) = '' OR city IS NULL;

UPDATE public.schools 
SET state = 'Unknown State'
WHERE trim(state) = '' OR state IS NULL;

-- Now add the validation constraints (simplified)
ALTER TABLE public.schools 
ADD CONSTRAINT schools_name_length CHECK (length(trim(name)) >= 2 AND length(name) <= 100),
ADD CONSTRAINT schools_name_format CHECK (name ~ '^[a-zA-Z\s\-\.&'']+$'),
ADD CONSTRAINT schools_address_length CHECK (length(trim(address)) >= 5 AND length(address) <= 200),
ADD CONSTRAINT schools_city_length CHECK (length(trim(city)) >= 2 AND length(city) <= 50),
ADD CONSTRAINT schools_city_format CHECK (city ~ '^[a-zA-Z\s\-\.]+$'),
ADD CONSTRAINT schools_state_length CHECK (length(trim(state)) >= 2 AND length(state) <= 50),
ADD CONSTRAINT schools_state_format CHECK (state ~ '^[a-zA-Z\s]+$'),
ADD CONSTRAINT schools_contact_length CHECK (length(trim(contact)) >= 10 AND length(contact) <= 15),
ADD CONSTRAINT schools_email_length CHECK (length(trim(email_id)) >= 5 AND length(email_id) <= 100);

-- Create validation trigger function
CREATE OR REPLACE FUNCTION validate_school_fields()
RETURNS TRIGGER AS $$
BEGIN
  -- Trim all fields
  NEW.name = trim(NEW.name);
  NEW.address = trim(NEW.address);
  NEW.city = trim(NEW.city);
  NEW.state = trim(NEW.state);
  NEW.contact = trim(NEW.contact);
  NEW.email_id = trim(NEW.email_id);
  
  -- Check for empty fields
  IF NEW.name = '' THEN
    RAISE EXCEPTION 'School name cannot be empty';
  END IF;
  
  IF NEW.address = '' THEN
    RAISE EXCEPTION 'Address cannot be empty';
  END IF;
  
  IF NEW.city = '' THEN
    RAISE EXCEPTION 'City cannot be empty';
  END IF;
  
  IF NEW.state = '' THEN
    RAISE EXCEPTION 'State cannot be empty';
  END IF;
  
  IF NEW.contact = '' THEN
    RAISE EXCEPTION 'Contact cannot be empty';
  END IF;
  
  IF NEW.email_id = '' THEN
    RAISE EXCEPTION 'Email cannot be empty';
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
CREATE TRIGGER validate_school_fields_trigger
  BEFORE INSERT OR UPDATE ON public.schools
  FOR EACH ROW
  EXECUTE FUNCTION validate_school_fields();