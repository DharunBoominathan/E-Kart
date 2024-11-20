export function initializePage() {
    console.log('Dashboard page initialized');

    // Parse JSON data from embedded scripts
    const ordersData = JSON.parse(document.getElementById('ordersDataScript').textContent);
    const ageGroupsData = JSON.parse(document.getElementById('ageGroupsDataScript').textContent);
    const productSalesData = JSON.parse(document.getElementById('productSalesDataScript').textContent);

    // Chart Data Map
    const chartDataMap = {
        orders: {
            type: 'line',
            data: {
                labels: Object.keys(ordersData),
                datasets: [{
                    label: 'Orders',
                    data: Object.values(ordersData),
                    borderColor: '#1a7ac4',
                    backgroundColor: 'rgba(26, 122, 196, 0.2)',
                    fill: true,
                }]
            },
        },
        users: {
            type: 'bar',
            data: {
                labels: Object.keys(ageGroupsData),
                datasets: [{
                    label: 'Users',
                    data: Object.values(ageGroupsData),
                    backgroundColor: '#1a7ac4',
                }]
            },
        },
        products: {
            type: 'pie',
            data: {
                labels: Object.keys(productSalesData),
                datasets: [{
                    label: 'Sales',
                    data: Object.values(productSalesData),
                    backgroundColor: ['#1a7ac4', '#ff7b72', '#ffcd56', '#4bc0c0', '#9966ff'],
                }]
            },
        }
    };

    let currentChart = null; // To track the current chart instance

    // Load Chart with Animation
  const loadChart = (chartType) => {
      const chartContainer = document.getElementById('chartContainer');
      chartContainer.classList.add('fade-out'); // Apply fade-out animation

      setTimeout(() => {
          // Clear existing canvas content
          chartContainer.innerHTML = '<canvas id="dynamicChart"></canvas>';
          const ctx = document.getElementById('dynamicChart').getContext('2d');

          // Destroy the previous chart if exists
          if (currentChart) currentChart.destroy();

          // Create new chart with specific size options
          currentChart = new Chart(ctx, {
              type: chartDataMap[chartType].type,
              data: chartDataMap[chartType].data,
              options: {
                  maintainAspectRatio: false, // Allow custom dimensions
                  responsive: true,
                  layout: {
                      padding: 10, // Optional padding
                  },
                  plugins: {
                      legend: {
                          display: true,
                          position: 'top',
                      },
                  },
              },
          });

          // Set the canvas size directly
          const dynamicChartCanvas = document.getElementById('dynamicChart');
          dynamicChartCanvas.style.height = '425px'; // Adjust height in pixels

          chartContainer.classList.remove('fade-out'); // Remove fade-out animation
          chartContainer.classList.add('fade-in'); // Apply fade-in animation

          setTimeout(() => chartContainer.classList.remove('fade-in'), 500); // Remove fade-in class after animation
      }, 300); // Allow fade-out animation to complete
  };


    // Tab navigation logic
    const tabs = document.querySelectorAll('.tab');
    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            tabs.forEach(t => t.classList.remove('active'));
            tab.classList.add('active');
            loadChart(tab.dataset.chart);
        });
    });

    // Initialize with the first tab
    if (tabs.length > 0) {
        tabs[0].click();
    }
}
