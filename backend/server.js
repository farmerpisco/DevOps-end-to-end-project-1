const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.get('/health', (req, res) => {
	  res.json({ status: 'healthy', timestamp: new Date() });
});

app.get('/api/products', (req, res) => {
	  res.json([
		      { id: 1, name: 'Product 1', price: 29.99 },
		      { id: 2, name: 'Product 2', price: 49.99 }
		    ]);
});

app.listen(PORT, () => {
	  console.log(`Server running on port ${PORT}`);
});
