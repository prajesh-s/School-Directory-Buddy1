import { Link, useLocation } from "react-router-dom"
import { Button } from "./ui/button"

const Navigation = () => {
  const location = useLocation()

  return (
    <nav className="bg-card border-b border-border shadow-sm">
      <div className="container mx-auto px-4">
        <div className="flex items-center justify-between h-16">
          <Link to="/" className="text-xl font-bold text-foreground">
            School Directory
          </Link>
          
          <div className="flex space-x-4">
            <Button
              variant={location.pathname === "/add-school" ? "default" : "outline"}
              asChild
            >
              <Link to="/add-school">Add School</Link>
            </Button>
            <Button
              variant={location.pathname === "/schools" ? "default" : "outline"}
              asChild
            >
              <Link to="/schools">View Schools</Link>
            </Button>
          </div>
        </div>
      </div>
    </nav>
  )
}

export default Navigation