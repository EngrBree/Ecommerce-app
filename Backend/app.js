const express = require('express');
const dotenv = require('dotenv');
const authRoutes = require('./routes/authRoutes');
const productRoutes=require('./routes/productsRoute')
const cartRoutes=require('./routes/cartRoutes')
const favouriteRoutes=require('./routes/favouritesRoutes')

dotenv.config();
const app = express();
app.use(express.json());
app.use('/uploads', express.static('public/uploads'));


app.use('/auth', authRoutes);
app.use('/products',productRoutes);
app.use('/cart',cartRoutes);
app.use('/favourites',favouriteRoutes)


const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
