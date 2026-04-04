-- Create RPC to handle secure unsubscription for both profiles and anonymous subscribers
CREATE OR REPLACE FUNCTION unsubscribe_recipient(recipient_ref text)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    BEGIN
      -- Securely remove by unguessage UUID. 
      -- If it's an anonymous subscriber, their primary key is randomly generated UUID.
      DELETE FROM newsletter_subscribers WHERE id = recipient_ref::uuid;
      
      -- If it's a registered profile, their user_id is their auth UUID.
      UPDATE profiles SET newsletter_opt_in = false 
      WHERE user_id = recipient_ref::uuid OR id = recipient_ref::uuid;
      
      RETURN true;
    EXCEPTION WHEN OTHERS THEN
      -- In case casting to uuid fails, ignore
      RETURN false;
    END;
END;
$$;
