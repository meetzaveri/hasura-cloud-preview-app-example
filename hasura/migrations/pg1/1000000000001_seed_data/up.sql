INSERT INTO public.user (username, password, display_name, is_superuser) VALUES
    ('admin', crypt('admin', gen_salt('bf')), 'Administrator', true),
    ('user', crypt('user', gen_salt('bf')), 'User', false);

INSERT INTO public.product (name, description) VALUES
    ('White Socks', 'A nice pair of white socks'),
    ('Blue Shirt', 'A fancy blue shirt'),
    ('Red Shoes', 'Expensive red shoes'),
    ('Grey Pants', 'Simple grey pants');