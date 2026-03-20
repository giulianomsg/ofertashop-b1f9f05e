-- Removes the discount condition, only tracking actual price changes
CREATE OR REPLACE FUNCTION log_price_change()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') OR 
       (TG_OP = 'UPDATE' AND NEW.price IS DISTINCT FROM OLD.price) THEN
        INSERT INTO public.price_history (product_id, price)
        VALUES (NEW.id, NEW.price);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
