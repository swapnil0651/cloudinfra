export default function App() {
  const data = {
    name: "Swapnil",
    imageUrl: "https://myimg2.s3.ap-south-1.amazonaws.com/Screenshot+2023-10-12+105127.png",
    altText: "Greeting Image"
  };

  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-gray-100">
      <h1 className="text-4xl font-bold mb-8 text-gray-800">
        Hi {data.name}!
      </h1>
      <img 
        src={data.imageUrl} 
        alt={data.altText}
        className="rounded-lg shadow-lg max-w-md"
      />
    </div>
  );
}