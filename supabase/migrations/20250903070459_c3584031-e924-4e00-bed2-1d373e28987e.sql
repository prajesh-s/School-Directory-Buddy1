-- Add database-level validation constraints for schools table

-- Add check constraints for field lengths and formats
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
ADD CONSTRAINT schools_email_format CHECK (email_id ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

-- Add NOT NULL constraints for required fields (they should already be NOT NULL but ensuring)
ALTER TABLE public.schools 
ALTER COLUMN name SET NOT NULL,
ALTER COLUMN address SET NOT NULL,
ALTER COLUMN city SET NOT NULL,
ALTER COLUMN state SET NOT NULL,
ALTER COLUMN contact SET NOT NULL,
ALTER COLUMN email_id SET NOT NULL;

-- Create validation trigger function to prevent empty/whitespace-only values
CREATE OR REPLACE FUNCTION validate_school_fields()
RETURNS TRIGGER AS $$
BEGIN
  -- Validate name
  IF trim(NEW.name) = '' THEN
    RAISE EXCEPTION 'School name cannot be empty or contain only whitespace';
  END IF;
  
  -- Validate address
  IF trim(NEW.address) = '' THEN
    RAISE EXCEPTION 'Address cannot be empty or contain only whitespace';
  END IF;
  
  -- Validate city
  IF trim(NEW.city) = '' THEN
    RAISE EXCEPTION 'City cannot be empty or contain only whitespace';
  END IF;
  
  -- Validate state
  IF trim(NEW.state) = '' THEN
    RAISE EXCEPTION 'State cannot be empty or contain only whitespace';
  END IF;
  
  -- Validate contact
  IF trim(NEW.contact) = '' THEN
    RAISE EXCEPTION 'Contact cannot be empty or contain only whitespace';
  END IF;
  
  -- Validate email
  IF trim(NEW.email_id) = '' THEN
    RAISE EXCEPTION 'Email cannot be empty or contain only whitespace';
  END IF;
  
  -- Trim whitespace from all fields before saving
  NEW.name = trim(NEW.name);
  NEW.address = trim(NEW.address);
  NEW.city = trim(NEW.city);
  NEW.state = trim(NEW.state);
  NEW.contact = trim(NEW.contact);
  NEW.email_id = trim(NEW.email_id);
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to run validation on INSERT and UPDATE
CREATE TRIGGER validate_school_fields_trigger
  BEFORE INSERT OR UPDATE ON public.schools
  FOR EACH ROW
  EXECUTE FUNCTION validate_school_fields();

-- Add unique constraint for email to prevent duplicate schools
ALTER TABLE public.schools 
ADD CONSTRAINT schools_email_unique UNIQUE (email_id);