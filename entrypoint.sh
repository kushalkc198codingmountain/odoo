#!/bin/bash

# Function to initialize Odoo
initialize_odoo() {
    echo "Initializing Odoo..."
    ./odoo-bin -c $ODOO_CONF -d odoo --init=all
}

# Navigate to the ODOO_HOME directory
cd $ODOO_HOME

# Activate the virtual environment
source venv/bin/activate

# Run initialization only on first start
if [ ! -f /.initialized ]; then
    touch /.initialized
    initialize_odoo
fi

# Start Odoo
echo "Starting Odoo..."
exec ./odoo-bin -c $ODOO_CONF
