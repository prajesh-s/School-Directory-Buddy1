import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Link } from "react-router-dom"
import { GraduationCap, Plus, Search } from "lucide-react"
import Navigation from "@/components/Navigation"

const Index = () => {
  return (
    <div className="min-h-screen bg-background">
      <Navigation />
      
      <div className="container mx-auto px-4 py-12">
        <div className="text-center mb-12">
          <div className="flex justify-center mb-6">
            <div className="p-4 bg-primary/10 rounded-full">
              <GraduationCap className="h-12 w-12 text-primary" />
            </div>
          </div>
          <h1 className="text-4xl font-bold mb-4">School Directory Buddy</h1>
          <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
            Your comprehensive platform for managing and discovering schools. Add new schools to the directory or browse existing institutions.
          </p>
        </div>

        <div className="grid md:grid-cols-2 gap-8 max-w-4xl mx-auto">
          <Card className="hover:shadow-lg transition-shadow duration-300">
            <CardHeader className="text-center">
              <div className="flex justify-center mb-4">
                <div className="p-3 bg-primary/10 rounded-full">
                  <Plus className="h-8 w-8 text-primary" />
                </div>
              </div>
              <CardTitle>Add New School</CardTitle>
              <CardDescription>
                Register a new educational institution in our directory with complete details and images.
              </CardDescription>
            </CardHeader>
            <CardContent className="text-center">
              <Button asChild size="lg" className="w-full">
                <Link to="/add-school">
                  Add School
                </Link>
              </Button>
            </CardContent>
          </Card>

          <Card className="hover:shadow-lg transition-shadow duration-300">
            <CardHeader className="text-center">
              <div className="flex justify-center mb-4">
                <div className="p-3 bg-primary/10 rounded-full">
                  <Search className="h-8 w-8 text-primary" />
                </div>
              </div>
              <CardTitle>Browse Schools</CardTitle>
              <CardDescription>
                Discover and explore schools in our comprehensive directory with detailed information.
              </CardDescription>
            </CardHeader>
            <CardContent className="text-center">
              <Button asChild size="lg" variant="outline" className="w-full">
                <Link to="/schools">
                  View Schools
                </Link>
              </Button>
            </CardContent>
          </Card>
        </div>

        <div className="text-center mt-12">
          <div className="bg-muted rounded-lg p-8">
            <h2 className="text-2xl font-semibold mb-4">Features</h2>
            <div className="grid md:grid-cols-3 gap-6 text-center">
              <div>
                <h3 className="font-medium mb-2">Easy Registration</h3>
                <p className="text-sm text-muted-foreground">Simple form with validation to add schools quickly</p>
              </div>
              <div>
                <h3 className="font-medium mb-2">Image Upload</h3>
                <p className="text-sm text-muted-foreground">Upload and store school images securely</p>
              </div>
              <div>
                <h3 className="font-medium mb-2">Responsive Design</h3>
                <p className="text-sm text-muted-foreground">Works perfectly on desktop and mobile devices</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Index;
