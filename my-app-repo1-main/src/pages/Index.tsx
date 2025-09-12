import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Link } from "react-router-dom"
import { GraduationCap, Plus, Search, Shield, Lock } from "lucide-react"
import Navigation from "@/components/Navigation"
import { useAuth } from "@/contexts/AuthContext"

const Index = () => {
  const { user } = useAuth();

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
            Your comprehensive platform for managing and discovering schools. 
            {!user && " Sign in with email OTP to manage schools."}
          </p>
        </div>

        {!user && (
          <div className="bg-primary/5 border border-primary/20 rounded-lg p-6 mb-8 max-w-2xl mx-auto">
            <div className="flex items-center justify-center space-x-2 mb-3">
              <Shield className="h-5 w-5 text-primary" />
              <h3 className="font-semibold text-primary">Authentication Required</h3>
            </div>
            <p className="text-sm text-muted-foreground text-center mb-4">
              School management features are protected. You can browse schools without signing in, 
              but adding or editing schools requires email verification.
            </p>
            <div className="text-center">
              <Button asChild>
                <Link to="/auth">Sign In with Email OTP</Link>
              </Button>
            </div>
          </div>
        )}

        <div className="grid md:grid-cols-2 gap-8 max-w-4xl mx-auto">
          <Card className={`hover:shadow-lg transition-shadow duration-300 ${!user ? 'opacity-60' : ''}`}>
            <CardHeader className="text-center">
              <div className="flex justify-center mb-4">
                <div className="p-3 bg-primary/10 rounded-full relative">
                  <Plus className="h-8 w-8 text-primary" />
                  {!user && <Lock className="h-4 w-4 absolute -top-1 -right-1 bg-background border rounded-full p-0.5" />}
                </div>
              </div>
              <CardTitle>Add New School</CardTitle>
              <CardDescription>
                Register a new educational institution in our directory with complete details and images.
                {!user && " (Requires authentication)"}
              </CardDescription>
            </CardHeader>
            <CardContent className="text-center">
              {user ? (
                <Button asChild size="lg" className="w-full">
                  <Link to="/add-school">Add School</Link>
                </Button>
              ) : (
                <Button asChild size="lg" variant="outline" className="w-full">
                  <Link to="/auth">Sign In to Add School</Link>
                </Button>
              )}
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
                (Available to everyone)
              </CardDescription>
            </CardHeader>
            <CardContent className="text-center">
              <Button asChild size="lg" variant="outline" className="w-full">
                <Link to="/schools">View Schools</Link>
              </Button>
            </CardContent>
          </Card>
        </div>

        <div className="text-center mt-12">
          <div className="bg-muted rounded-lg p-8">
            <h2 className="text-2xl font-semibold mb-4">Features</h2>
            <div className="grid md:grid-cols-3 gap-6 text-center">
              <div>
                <h3 className="font-medium mb-2">Email OTP Authentication</h3>
                <p className="text-sm text-muted-foreground">Secure 6-digit code login with 10-minute expiry</p>
              </div>
              <div>
                <h3 className="font-medium mb-2">Protected Management</h3>
                <p className="text-sm text-muted-foreground">Only authenticated users can add or edit schools</p>
              </div>
              <div>
                <h3 className="font-medium mb-2">Public Directory</h3>
                <p className="text-sm text-muted-foreground">Anyone can browse and view school information</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Index;
