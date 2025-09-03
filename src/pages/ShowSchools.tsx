import { useState, useEffect } from "react"
import { supabase } from "@/integrations/supabase/client"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { MapPin, Phone, Mail } from "lucide-react"
import Navigation from "@/components/Navigation"

// School type definition
type School = {
  id: number
  name: string
  address: string
  city: string
  state: string
  contact: string
  email_id: string
  image: string | null
  created_at: string
}

const ShowSchools = () => {
  const [schools, setSchools] = useState<School[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchSchools()
  }, [])

  const fetchSchools = async () => {
    try {
      const { data, error } = await supabase
        .from('schools')
        .select('*')
        .order('created_at', { ascending: false })
        
      if (error) throw error
      
      setSchools(data || [])
    } catch (error) {
      console.error('Error fetching schools:', error)
    } finally {
      setLoading(false)
    }
  }

  if (loading) {
    return (
      <div className="min-h-screen bg-background">
        <Navigation />
        <div className="container mx-auto px-4 py-8">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            {[...Array(8)].map((_, i) => (
              <Card key={i} className="overflow-hidden">
                <div className="h-48 bg-muted animate-pulse" />
                <CardContent className="p-4">
                  <div className="h-4 bg-muted rounded animate-pulse mb-2" />
                  <div className="h-3 bg-muted rounded animate-pulse mb-1" />
                  <div className="h-3 bg-muted rounded animate-pulse w-3/4" />
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-background">
      <Navigation />
      
      <div className="container mx-auto px-4 py-8">
        <div className="text-center mb-8">
          <h1 className="text-3xl font-bold mb-2">School Directory</h1>
          <p className="text-muted-foreground">
            Discover schools in your area - {schools.length} schools found
          </p>
        </div>

        {schools.length === 0 ? (
          <div className="text-center py-12">
            <p className="text-lg text-muted-foreground mb-4">No schools found</p>
            <p className="text-sm text-muted-foreground">
              Be the first to add a school to the directory!
            </p>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            {schools.map((school) => (
              <Card key={school.id} className="overflow-hidden hover:shadow-lg transition-shadow duration-300 group">
                <div className="relative h-48 overflow-hidden">
                  {school.image ? (
                    <img
                      src={school.image}
                      alt={school.name}
                      className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                    />
                  ) : (
                    <div className="w-full h-full bg-muted flex items-center justify-center">
                      <div className="text-center">
                        <div className="text-4xl mb-2">🏫</div>
                        <p className="text-sm text-muted-foreground">No Image</p>
                      </div>
                    </div>
                  )}
                  <div className="absolute top-2 right-2">
                    <Badge variant="secondary" className="bg-background/80 backdrop-blur-sm">
                      {school.state}
                    </Badge>
                  </div>
                </div>
                
                <CardContent className="p-4">
                  <h3 className="font-semibold text-lg mb-2 line-clamp-1" title={school.name}>
                    {school.name}
                  </h3>
                  
                  <div className="space-y-2 text-sm">
                    <div className="flex items-start gap-2">
                      <MapPin className="h-4 w-4 mt-0.5 text-muted-foreground flex-shrink-0" />
                      <div>
                        <p className="line-clamp-1" title={school.address}>{school.address}</p>
                        <p className="text-muted-foreground">{school.city}, {school.state}</p>
                      </div>
                    </div>
                    
                    <div className="flex items-center gap-2">
                      <Phone className="h-4 w-4 text-muted-foreground flex-shrink-0" />
                      <p className="line-clamp-1" title={school.contact}>{school.contact}</p>
                    </div>
                    
                    <div className="flex items-center gap-2">
                      <Mail className="h-4 w-4 text-muted-foreground flex-shrink-0" />
                      <p className="line-clamp-1" title={school.email_id}>{school.email_id}</p>
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        )}
      </div>
    </div>
  )
}

export default ShowSchools