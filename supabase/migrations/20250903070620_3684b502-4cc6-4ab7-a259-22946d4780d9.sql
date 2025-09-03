-- Add database-level validation constraints for schools table (safe version)

-- Drop existing constraints if they exist to avoid conflicts
DO $$ 
BEGIN
  -- Drop existing constraints if they exist
  IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'schools_name_length') THEN
    ALTER TABLE public.schools DROP CONSTRAINT schools_name_length;
  END IF;
  
  IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'schools_name_format') THEN
    ALTER TABLE public.schools DROP CONSTRAINT schools_name_format;
  END IF;
  
  IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'schools_address_length') THEN
    ALTER TABLE public.schools DROP CONSTRAINT schools_address_length;
  END IF;
  
  IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'schools_city_length') THEN
    ALTER TABLE public.schools DROP CONSTRAINT schools_city_length;
  END IF;
  
  IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'schools_city_format') THEN
    ALTER TABLE public.schools DROP CONSTRAINT schools_city_format;
  END IF;
  
  IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'schools_state_length') THEN
    ALTER TABLE public.schools DROP CONSTRAINT schools_state_length;
  END IF;
  
  IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'schools_state_format') THEN
    ALTER TABLE public.schools DROP CONSTRAINT schools_state_format;
  END IF;
  
  IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'schools_contact_length') THEN
    ALTER TABLE public.schools DROP CONSTRAINT schools_contact_length;
  END IF;
  
  IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'schools_contact_format') THEN
    ALTER TABLE public.schools DROP CONSTRAINT schools_contact_format;
  END IF;
  
  IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'schools_email_length') THEN
    ALTER TABLE public.schools DROP CONSTRAINT schools_email_length;
  END IF;
  
  IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'schools_email_format') THEN
    ALTER TABLE public.schools DROP CONSTRAINT schools_email_format;
  END IF;
  
  IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'schools_email_unique') THEN
    ALTER TABLE public.schools DROP CONSTRAINT schools_email_unique;
  END IF;
END $$;

-- Add comprehensive validation constraints
ALTER TABLE public.schools 
ADD CONSTRAINT schools_name_length CHECK (length(trim(name)) >= 2 AND length(name) <= 100),
ADD CONSTRAINT schools_name_format CHECK (name ~ '^[a-zA-Z\s\-\.&'']+$'),
ADD CONSTRAINT schools_address_length CHECK (length(trim(address)) >= 10 AND length(address) <= 200),
ADD CONSTRAINT schools_city_length CHECK (length(trim(city)) >= 2 AND length(city) <= 50),
ADD CONSTRAINT schools_city_format CHECK (city ~ '^[a-zA-Z\s\-\.]+$'),
ADD CONSTRAINT schools_state_length CHECK (length(trim(state)) >= 2 AND length(state) <= 50),
ADD CONSTRAINT schools_state_format CHECK (state ~ '^[a-zA-Z\s]+$'),
ADD CONSTRAINT schools_contact_length CHECK (length(trim(contact)) >= 10 AND length(contact) <= 15),
ADD CONSTRAINT schools_contact_format CHECK (contact ~ '^[\+]?[1-9][\d]{9,14}$'),
ADD CONSTRAINT schools_email_length CHECK (length(trim(email_id)) >= 5 AND length(email_id) <= 100),
ADD CONSTRAINT schools_email_format CHECK (email_id ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
ADD CONSTRAINT schools_email_unique UNIQUE (email_id);

-- Drop existing validation function and trigger if they exist
DROP TRIGGER IF EXISTS validate_school_fields_trigger ON public.schools;
DROP FUNCTION IF EXISTS validate_school_fields();

-- Create validation trigger function to prevent empty/whitespace-only values
CREATE OR REPLACE FUNCTION validate_school_fields()
RETURNS TRIGGER AS $$
BEGIN
  -- Validate and trim whitespace from all fields before saving
  NEW.name = trim(NEW.name);
  NEW.address = trim(NEW.address);
  NEW.city = trim(NEW.city);
  NEW.state = trim(NEW.state);
  NEW.contact = trim(NEW.contact);
  NEW.email_id = trim(NEW.email_id);
  
  -- Validate that fields are not empty after trimming
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