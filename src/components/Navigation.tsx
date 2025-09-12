import { Link, useLocation } from "react-router-dom"
import { Button } from "./ui/button"
import { useAuth } from "@/contexts/AuthContext"
import { LogIn, LogOut, User } from "lucide-react"

const Navigation = () => {
  const location = useLocation()
  const { user, signOut } = useAuth()

  const handleSignOut = async () => {
    await signOut()
  }

  return (
    <nav className="bg-card border-b border-border shadow-sm">
      <div className="container mx-auto px-4">
        <div className="flex items-center justify-between h-16">
          <Link to="/" className="text-xl font-bold text-foreground">
            School Directory
          </Link>
          
          <div className="flex items-center space-x-4">
            <Button
              variant={location.pathname === "/schools" ? "default" : "outline"}
              asChild
            >
              <Link to="/schools">View Schools</Link>
            </Button>
            
            {user ? (
              <>
                <Button
                  variant={location.pathname === "/add-school" ? "default" : "outline"}
                  asChild
                >
                  <Link to="/add-school">Add School</Link>
                </Button>
                <div className="flex items-center space-x-2">
                  <User className="h-4 w-4" />
                  <span className="text-sm text-muted-foreground">{user.email}</span>
                </div>
                <Button
                  variant="ghost"
                  onClick={handleSignOut}
                  className="flex items-center space-x-2"
                >
                  <LogOut className="h-4 w-4" />
                  <span>Sign Out</span>
                </Button>
              </>
            ) : (
              <Button
                variant={location.pathname === "/auth" ? "default" : "outline"}
                asChild
              >
                <Link to="/auth" className="flex items-center space-x-2">
                  <LogIn className="h-4 w-4" />
                  <span>Sign In</span>
                </Link>
              </Button>
            )}
          </div>
        </div>
      </div>
    </nav>
  )
}

export default Navigation