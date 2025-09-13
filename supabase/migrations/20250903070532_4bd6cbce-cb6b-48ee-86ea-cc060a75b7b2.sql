-- Clean up existing data and add validation constraints for schools table

-- First, clean up existing data that might not match the new constraints
UPDATE public.schools 
SET 
  name = regexp_replace(name, '[^a-zA-Z\s\-\.&'']', '', 'g'),
  city = regexp_replace(city, '[^a-zA-Z\s\-\.]', '', 'g'),
  state = regexp_replace(state, '[^a-zA-Z\s]', '', 'g'),
  contact = regexp_replace(contact, '[^\+0-9]', '', 'g')
WHERE 
  name !~ '^[a-zA-Z\s\-\.&'']+$' OR
  city !~ '^[a-zA-Z\s\-\.]+$' OR
  state !~ '^[a-zA-Z\s]+$' OR
  contact !~ '^[\+]?[1-9][\d]{9,14}$';

-- Handle any schools with invalid names that might become empty after cleanup
UPDATE public.schools 
SET name = 'Unknown School ' || id::text
WHERE trim(name) = '' OR name IS NULL;

-- Handle any cities that might become empty after cleanup
UPDATE public.schools 
SET city = 'Unknown City'
WHERE trim(city) = '' OR city IS NULL;

-- Handle any states that might become empty after cleanup
UPDATE public.schools 
SET state = 'Unknown State'
WHERE trim(state) = '' OR state IS NULL;

-- Now add the validation constraints
ALTER TABLE public.schools 
ADD CONSTRAINT schools_name_length CHECK (length(trim(name)) >= 2 AND length(name) <= 100),
ADD CONSTRAINT schools_name_format CHECK (name ~ '^[a-zA-Z\s\-\.&'']+$'),
ADD CONSTRAINT schools_address_length CHECK (length(trim(address)) >= 5 AND length(address) <= 200),
ADD CONSTRAINT schools_city_length CHECK (length(trim(city)) >= 2 AND length(city) <= 50),
ADD CONSTRAINT schools_city_format CHECK (city ~ '^[a-zA-Z\s\-\.]+$'),
ADD CONSTRAINT schools_state_length CHECK (length(trim(state)) >= 2 AND length(state) <= 50),
ADD CONSTRAINT schools_state_format CHECK (state ~ '^[a-zA-Z\s]+$'),
ADD CONSTRAINT schools_contact_length CHECK (length(trim(contact)) >= 10 AND length(contact) <= 15),
ADD CONSTRAINT schools_email_length CHECK (length(trim(email_id)) >= 5 AND length(email_id) <= 100),
ADD CONSTRAINT schools_email_format CHECK (email_id ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

-- Create validation trigger function to prevent empty/whitespace-only values
CREATE OR REPLACE FUNCTION validate_school_fields()
RETURNS TRIGGER AS $$
BEGIN
  -- Validate and trim all fields
  NEW.name = trim(NEW.name);
  NEW.address = trim(NEW.address);
  NEW.city = trim(NEW.city);
  NEW.state = trim(NEW.state);
  NEW.contact = trim(NEW.contact);
  NEW.email_id = trim(NEW.email_id);
  
  -- Check for empty fields after trimming
  IF NEW.name = '' THEN
    RAISE EXCEPTION 'School name cannot be empty or contain only whitespace';
  END IF;
  
  IF NEW.address = '' THEN
    RAISE EXCEPTION 'Address cannot be empty or contain only whitespace';
  END IF;
  
  IF NEW.city = '' THEN
    RAISE EXCEPTION 'City cannot be empty or contain only whitespace';
  END IF;
  
  IF NEW.state = '' THEN
    RAISE EXCEPTION 'State cannot be empty or contain only whitespace';
  END IF;
  
  IF NEW.contact = '' THEN
    RAISE EXCEPTION 'Contact cannot be empty or contain only whitespace';
  END IF;
  
  IF NEW.email_id = '' THEN
    RAISE EXCEPTION 'Email cannot be empty or contain only whitespace';
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to run validation on INSERT and UPDATE
CREATE TRIGGER validate_school_fields_trigger
  BEFORE INSERT OR UPDATE ON public.schools
  FOR EACH ROW
  EXECUTE FUNCTION validate_school_fields();